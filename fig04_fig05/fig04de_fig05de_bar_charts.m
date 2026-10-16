% Figs. 4D, 4E, 5D, and 5E: stacked bar charts of how often a synchronizing or
% desynchronizing input switched the network's state, summed over all input
% times. Top subplot: Fig. 4D (left bar) and 4E (right bar). Bottom subplot:
% Fig. 5D (left bar) and 5E (right bar). Uses the input amplitude of 1.0.
%
% This uses the visual-inspection scoring of the sweep simulations in
% `data/`, so no simulations need to be run first. See the "Notes" sheet of
% each spreadsheet for what each scoring letter means.
%
% Original filename: create_bar_charts_single_phase_bin.m. The original loaded
% a .mat file imported from the spreadsheets in `data/`, which was not
% preserved; this version reads the spreadsheets directly instead.

% Add DynaSim and the model to the MATLAB path, and create the output directory
addpath(fullfile(fileparts(mfilename('fullpath')), '..'));
output_dir = setup_thalcort('fig04_fig05');

data_dir = fullfile(fileparts(mfilename('fullpath')), 'data');
scoring_data = @(filename) load_scoring_data(data_dir, filename);

nn = 0;

iapp_column_names = ["Iapp05", "Iapp10"];
number_of_categories = 5;

%% Compute the proportion of each scoring category

% Rows 22 to 76 are the input times 3100 ms to 8500 ms
s30artsync = compute_total_avgs(scoring_data('fig04d_sync_sweep_scoring.xlsx'), 22, 76);
s34artsync = compute_total_avgs(scoring_data('fig05d_sync_sweep_scoring.xlsx'), 22, 76);
s30desync = compute_total_avgs(scoring_data('fig04e_desync_sweep_scoring.xlsx'), 22, 76);
s34desync = compute_total_avgs(scoring_data('fig05e_desync_sweep_scoring.xlsx'), 22, 76);

combined_data = [s30artsync ; s34artsync ; s30desync ; s34desync];

nn = nn + 1;
h(nn) = figure(nn);
% for ii = 1:length(iapp_column_names)
%     subplot(210 + ii)
%     bar(s30artsync(:, [1:3] + (ii*number_of_categories - number_of_categories)), 'stacked')
%     bar(s30artsync(:, [1:number_of_categories] + (ii*number_of_categories - number_of_categories)), ...
%         'stacked', 'BarWidth', 1)
%     bar(s30artsync(:, [1:number_of_categories] + (ii*number_of_categories - number_of_categories)), ...
%     title(strcat("Proportion of simulation after Sync input that switched PAC type for ", iapp_column_names(ii)))
subplot(211)
% Put s30 artsync next to s30 DEsync
bar(combined_data([1 3], 6:10), 'stacked')
legend("All", "Most", "Half", "Some", "None", "Location", "eastoutside")
subplot(212)
% Put s34 artsync next to s34 DEsync
bar(combined_data([2 4], 6:10), 'stacked')
legend("All", "Most", "Half", "Some", "None", "Location", "eastoutside")
% end
print(h(nn), fullfile(output_dir, 'fig04de_fig05de_bar_charts'), '-dpng')



%%
function normd_bars = compute_total_avgs(data, time_index_begin, time_index_end)

number_phase_bins = 1;

% First column is numerators (how many hits), second column is denominators
% (how many total)

iapp_column_names = ["Iapp05", "Iapp10"];

% See explanation of each categories below in the main loop
number_of_categories = 5;

simplestBH =  zeros(number_phase_bins,number_of_categories*length(iapp_column_names));
simplestWAV = zeros(number_phase_bins,number_of_categories*length(iapp_column_names));

for ii = 1:length(iapp_column_names)
    for jj = time_index_begin:time_index_end
        switch data.(iapp_column_names(ii))(jj)
            case {"a", "x"}
                % TODO category explanation here
                simplestBH(1, (number_of_categories*ii - number_of_categories) + 1) = ...
                    simplestBH(1, (number_of_categories*ii - number_of_categories) + 1) + 1;
            case {"m"}
                simplestBH(1, (number_of_categories*ii - number_of_categories) + 2) = ...
                    simplestBH(1, (number_of_categories*ii - number_of_categories) + 2) + 1;
            case {"h"}
                simplestBH(1, (number_of_categories*ii - number_of_categories) + 3) = ...
                    simplestBH(1, (number_of_categories*ii - number_of_categories) + 3) + 1;
            case {"s"}
                simplestBH(1, (number_of_categories*ii - number_of_categories) + 4) = ...
                    simplestBH(1, (number_of_categories*ii - number_of_categories) + 4) + 1;
            case {"n", "z"}
                simplestBH(1, (number_of_categories*ii - number_of_categories) + 5) = ...
                    simplestBH(1, (number_of_categories*ii - number_of_categories) + 5) + 1;

        end
    end
end

% Normalized
normdsimplestBH =  zeros(number_phase_bins,number_of_categories*length(iapp_column_names));
normdsimplestWAV = zeros(number_phase_bins,number_of_categories*length(iapp_column_names));

for ii = 1:number_phase_bins
    for jj = 1:length(iapp_column_names)
        denom_sum = sum(simplestBH(ii, (jj*number_of_categories - number_of_categories) + [1:number_of_categories]));
        if ~(denom_sum == 0)
            normdsimplestBH(ii, (jj*number_of_categories - number_of_categories) + [1:number_of_categories]) = ...
                simplestBH(ii, (jj*number_of_categories - number_of_categories) + [1:number_of_categories]) / denom_sum;
        end

        denom_sum = sum(simplestWAV(ii, (jj*number_of_categories - number_of_categories) + [1:number_of_categories]));
        if ~(denom_sum == 0)
            normdsimplestWAV(ii, (jj*number_of_categories - number_of_categories) + [1:number_of_categories]) = ...
                simplestWAV(ii, (jj*number_of_categories - number_of_categories) + [1:number_of_categories]) / denom_sum;
        end

    end
end

normd_bars = normdsimplestBH;

end

function data = load_scoring_data(data_dir, filename)
% Load the "Data" sheet of a scoring spreadsheet, with the scoring columns for
% input amplitudes 0.5 and 1.0 named `Iapp05` and `Iapp10` as strings.
data = readtable(fullfile(data_dir, filename), 'Sheet', 'Data', ...
                 'VariableNamingRule', 'preserve');
data = renamevars(data, {'Iapp0.5', 'Iapp1.0'}, {'Iapp05', 'Iapp10'});
data.Iapp05 = fillmissing(string(data.Iapp05), 'constant', "");
data.Iapp10 = fillmissing(string(data.Iapp10), 'constant', "");
end

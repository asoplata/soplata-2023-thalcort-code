
load('combined_s30_s34_artsync_desync_data.mat');

nn = 0;

iapp_column_names = ["Iapp05", "Iapp10"];
number_of_categories = 5;

%% s30 artsync

s30artsync = compute_bin_avgs(p25d32s05820221230s30artsyncstrdataS1, 22, 76);

nn = nn + 1;
h(nn) = figure(nn);
% plot across the different Iapps
for ii = 1:length(iapp_column_names)
    subplot(210 + ii)
%     bar(s30artsync(:, [1:3] + (ii*number_of_categories - number_of_categories)), 'stacked')
    bar(s30artsync(:, [1:number_of_categories] + (ii*number_of_categories - number_of_categories)), ...
        'stacked', 'BarWidth', 1)
%     title(strcat("Proportion of simulation after Sync input that switched PAC type for ", iapp_column_names(ii)))
    legend("All", "Most", "Half", "Some", "None", "Location", "eastoutside")
end
print(h(nn), strcat('p25d32s058_20221230_s30_artsync_str', '_bar_charts'), '-dpng')


%% s34 artsync
s34artsync = compute_bin_avgs(p25d32s05920221230s34artsyncstrdataS1, 22, 76);

nn = nn + 1;
h(nn) = figure(nn);
% plot across the different Iapps
for ii = 1:length(iapp_column_names)
    subplot(210 + ii)
%     bar(s30artsync(:, [1:3] + (ii*number_of_categories - number_of_categories)), 'stacked')
    bar(s34artsync(:, [1:number_of_categories] + (ii*number_of_categories - number_of_categories)), ...
        'stacked', 'BarWidth', 1)
%     title(strcat("Proportion of simulation after Sync input that switched PAC type for ", iapp_column_names(ii)))
    legend("All", "Most", "Half", "Some", "None", "Location", "eastoutside")
end
print(h(nn), strcat('p25d32s059_20221230_s34_artsync_str', '_bar_charts'), '-dpng')


%% s30 desync
s30desync = compute_bin_avgs(p25d32s06020221230s30DEsyncstrdataS1, 22, 76);

nn = nn + 1;
h(nn) = figure(nn);
% plot across the different Iapps
for ii = 1:length(iapp_column_names)
    subplot(210 + ii)
%     bar(s30artsync(:, [1:3] + (ii*number_of_categories - number_of_categories)), 'stacked')
    bar(s30desync(:, [1:number_of_categories] + (ii*number_of_categories - number_of_categories)),...
        'stacked', 'BarWidth', 1)
%     title(strcat("Proportion of simulation after DE-sync input that switched PAC type for ", iapp_column_names(ii)))
    legend("All", "Most", "Half", "Some", "None", "Location", "eastoutside")
end
print(h(nn), strcat('p25d32s060_20221230_s30_DEsync_str', '_bar_charts'), '-dpng')


%% s34 desync
s34desync = compute_bin_avgs(p25d32s06120221230s34DEsyncstrdataS1, 22, 76);

nn = nn + 1;
h(nn) = figure(nn);
% plot across the different Iapps
for ii = 1:length(iapp_column_names)
    subplot(210 + ii)
%     bar(s30artsync(:, [1:3] + (ii*number_of_categories - number_of_categories)), 'stacked')
    bar(s34desync(:, [1:number_of_categories] + (ii*number_of_categories - number_of_categories)),...
        'stacked', 'BarWidth', 1)
%     title(strcat("Proportion of simulation after DE-sync input that switched PAC type for ", iapp_column_names(ii)))
    legend("All", "Most", "Half", "Some", "None", "Location", "eastoutside")
end
print(h(nn), strcat('p25d32s061_20221230_s34_DEsync_str', '_bar_charts'), '-dpng')


% 
% 
% 
% t = tiledlayout('flow','TileSpacing','compact');
% for ii = 1:length(iapp_column_names)
%     nexttile
%     bar(normdsimplestBH(:, [1:3] + (ii*number_of_categories - number_of_categories)), 'stacked')
% end
% 
% lgd = legend("Interruption", "Tmax extension", "No effect");
% lgd.Layout.Tile = 6;
% 
% %% SWO ampl and phase
% 
% sim_name = 'p25d32s021_20221029_baseline_s7_cpu_i001';
% 
% if ~exist('sim_data','var')
%     sim_data = load(strcat('/example-output-directory/x7-scc-data/p25-thalcort-data/',...
%                        sim_name,...
%                        '/data/study_sim1_data.mat'));
% end
% 
% nexttile


function normd_bars = compute_bin_avgs(data, time_index_begin, time_index_end)

number_phase_bins = 8;

% First column is numerators (how many hits), second column is denominators
% (how many total)
% Simplest = 

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
                simplestBH(data.CleanedSWOPhaseBins1(jj), ...
                           (number_of_categories*ii - number_of_categories) + 1) = ...
                simplestBH(data.CleanedSWOPhaseBins1(jj), ...
                           (number_of_categories*ii - number_of_categories) + 1) + 1;
            case {"m"}
                simplestBH(data.CleanedSWOPhaseBins1(jj), ...
                           (number_of_categories*ii - number_of_categories) + 2) = ...
                simplestBH(data.CleanedSWOPhaseBins1(jj), ...
                           (number_of_categories*ii - number_of_categories) + 2) + 1;
            case {"h"}
                simplestBH(data.CleanedSWOPhaseBins1(jj), ...
                           (number_of_categories*ii - number_of_categories) + 3) = ...
                simplestBH(data.CleanedSWOPhaseBins1(jj), ...
                           (number_of_categories*ii - number_of_categories) + 3) + 1;
            case {"s"}
                simplestBH(data.CleanedSWOPhaseBins1(jj), ...
                           (number_of_categories*ii - number_of_categories) + 4) = ...
                simplestBH(data.CleanedSWOPhaseBins1(jj), ...
                           (number_of_categories*ii - number_of_categories) + 4) + 1;
            case {"n", "z"}
                simplestBH(data.CleanedSWOPhaseBins1(jj), ...
                           (number_of_categories*ii - number_of_categories) + 5) = ...
                simplestBH(data.CleanedSWOPhaseBins1(jj), ...
                           (number_of_categories*ii - number_of_categories) + 5) + 1;

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

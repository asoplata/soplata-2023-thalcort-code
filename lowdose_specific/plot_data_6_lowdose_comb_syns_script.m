%{
Load and plot the third dataset data_3_lowdose.mat corresponding to a
simulation with a "low-dose" of the direct and indirect effects of
propofol applied, so that figures may be assembled from these plots
using Inkscape.

Other script files will perform the actual simulation or, after all
simulations have been run, the data combine/cleanup script. This
script is solely for plotting.

Tip: after you've loaded the data, if you want a quick way to
visualize the entire simulation, you can simply run "dsPlot(<data
variable>)".
%}

%% Configuration

% Where the data is stored; this is set to the current directory by
% default. Note: Change the forward-slash to back-slash ('\') if on
% Windows.
output_dir = strcat(pwd, '/');

%% Part 3: Plotting low-dose propofol simulation
if ~exist('data_3_lowdose','var')
    load(strcat(output_dir,'data_3_lowdose.mat'))
end


% Choose the portion of the all the time series to display to better
% illustrate the simulation
time = data_3_lowdose.time;
dt = 0.01; % Time resolution of simulation, set in each sim file
downsample_factor = 10; % Set in each sim file
time_index_begin =  1; % In milliseconds
time_index_end =    15000; % In milliseconds
neuron = 2;


%% Run the comodulogram analysis on combined PYdr<-TC and PYdr<-PYso data
data_3_lowdose.labels{1,101} = 'comb_comodu_iAMPA';
data_3_lowdose.comb_comodu_iAMPA = data_3_lowdose.PYdr_TC_iAMPA_PYdr_TC_iAMPA_PYdr_TC + data_3_lowdose.PYdr_PYso_iAMPA_PYdr_PYso_JB12_IAMPA_PYdr_PYso_JB12;

data_3_lowdose = dsCalcComodulograms(data_3_lowdose, 'variable', 'comb_comodu_iAMPA');

% The filters used for the comodulograms are centered around the Cartesian
% product of {9, 12} Hz for alpha and {0.01, 1.01, 2.01} Hz for SWO.
current_data = data_3_lowdose.comb_comodu_iAMPA_Comodulograms_MUA.comodulograms;
% 'smaller_data' is for using only a subset of the original comodulogram
% data, since the initial transient of the simulation (the first few
% seconds) takes time to adapt to the steady-state of the simulation.
smaller_data = cell(size(current_data));

f601 = figure('Color', 'w', 'Units', 'normalized', 'InnerPosition', [0, 0, 1, 1]);
for ii=1:size(current_data,1)
    for jj=1:size(current_data,2)
        linear_index = (ii-1)*3+jj;
        smaller_data{ii,jj} = current_data{ii,jj}(:,:);
        ax{linear_index} = subplot(2,3,linear_index);
        imagesc(smaller_data{ii,jj})
        set(ax{linear_index}, 'XTickLabel',{},'YTickLabel',{})
        colorbar
    end
end
print(f601, 'f601_lowdose_comb_comodulograms', '-dpng','-r300')


%% Trough-max subrange
% Plot the first trough-max cycles of the simulation
time_index_begin =   3001; % In milliseconds
time_index_end =     6000; % In milliseconds
time_index_range = round(time_index_begin/(dt*downsample_factor)):round(time_index_end/(dt*downsample_factor));

% Plot the tmax TCPY and PYPY relevant traces, mean IAMPA currents, and
% those currents' spectra (our EEG signals)
f602 = figure('Color', 'w', 'Units', 'normalized', 'InnerPosition', [0, 0, 1, 1]);
ax1=subplot(3,1,1);
plot(time(time_index_range),mean(data_3_lowdose.PYdr_TC_iAMPA_PYdr_TC_iAMPA_PYdr_TC(time_index_range,:),2),'LineWidth',1.5,'color','k'); set(ax1,'XTickLabel',{},'box','off')
ax2=subplot(3,1,2);
plot(time(time_index_range),mean(data_3_lowdose.PYdr_PYso_iAMPA_PYdr_PYso_JB12_IAMPA_PYdr_PYso_JB12(time_index_range,:),2),'LineWidth',1.5,'color','k'); set(ax2,'XTickLabel',{},'box','off')
ax3=subplot(3,1,3);
plot(time(time_index_range),mean(data_3_lowdose.comb_comodu_iAMPA(time_index_range,:),2),'LineWidth',1.5,'color','k'); set(ax3,'XTickLabel',{},'box','off')
print(f602, 'f602_lowdose_tmax_iampa_comparison', '-dpng','-r300')

 
%% Peak-max subrange
% Plot ONLY a subset of peak-max cycles of the simulation
time_index_begin =   10001; % In milliseconds
time_index_end =     14000; % In milliseconds
neuron = 10;
time_index_range = round(time_index_begin/(dt*downsample_factor)):round(time_index_end/(dt*downsample_factor));

% Plot the tmax TCPY and PYPY relevant traces, mean IAMPA currents, and
% those currents' spectra (our EEG signals)
f603 = figure('Color', 'w', 'Units', 'normalized', 'InnerPosition', [0, 0, 1, 1]);
ax1=subplot(3,1,1);
plot(time(time_index_range),mean(data_3_lowdose.PYdr_TC_iAMPA_PYdr_TC_iAMPA_PYdr_TC(time_index_range,:),2),'LineWidth',1.5,'color','k'); set(ax1,'XTickLabel',{},'box','off')
ax2=subplot(3,1,2);
plot(time(time_index_range),mean(data_3_lowdose.PYdr_PYso_iAMPA_PYdr_PYso_JB12_IAMPA_PYdr_PYso_JB12(time_index_range,:),2),'LineWidth',1.5,'color','k'); set(ax2,'XTickLabel',{},'box','off')
ax3=subplot(3,1,3);
plot(time(time_index_range),mean(data_3_lowdose.comb_comodu_iAMPA(time_index_range,:),2),'LineWidth',1.5,'color','k'); set(ax3,'XTickLabel',{},'box','off')
print(f603, 'f603_lowdose_pmax_iampa_comparison', '-dpng','-r300')

% 
% % % Remove the dataset from RAM to free up space
% % clear data_3_lowdose
% 

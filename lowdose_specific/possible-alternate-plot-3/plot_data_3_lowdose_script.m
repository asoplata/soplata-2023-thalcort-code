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

% See prior plotting script
min_swo_freq_plotted = 4;

% Choose the portion of the all the time series to display to better
% illustrate the simulation
time = data_3_lowdose.time;
dt = 0.01; % Time resolution of simulation, set in each sim file
downsample_factor = 10; % Set in each sim file
time_index_begin =  1; % In milliseconds
time_index_end =    15000; % In milliseconds
neuron = 10;

% Plot the full time course of cell voltage traces, rastergram, and power spectra
time_index_range = round(time_index_begin/(dt*downsample_factor)):round(time_index_end/(dt*downsample_factor));

f301 = figure('Color', 'w', 'Units', 'normalized', 'InnerPosition', [0, 0, 1, 1]);
ax1=subplot(5,1,1); plot(time(time_index_range),data_3_lowdose.PYdr_v(time_index_range,neuron),'LineWidth',1,'color','k'); ylim([-100 50]); set(ax1,'XTickLabel',{},'YTickLabel',{},'box','off')
ax2=subplot(5,1,2); plot(time(time_index_range),data_3_lowdose.PYso_v(time_index_range,neuron),'LineWidth',1,'color','k'); ylim([-100 50]); set(ax2,'XTickLabel',{},'YTickLabel',{},'box','off')
ax3=subplot(5,1,3); plot(time(time_index_range),data_3_lowdose.IN_v(time_index_range,neuron),  'LineWidth',1,'color','k'); ylim([-100 50]); set(ax3,'XTickLabel',{},'YTickLabel',{},'box','off')
ax4=subplot(5,1,4); plot(time(time_index_range),data_3_lowdose.TC_v(time_index_range,neuron),  'LineWidth',1,'color','k'); ylim([-100 50]); set(ax4,'XTickLabel',{},'YTickLabel',{},'box','off')
ax5=subplot(5,1,5); plot(time(time_index_range),data_3_lowdose.TRN_v(time_index_range,neuron), 'LineWidth',1,'color','k'); ylim([-100 50]); set(ax5,'XTickLabel',{},'YTickLabel',{},'box','off')
print(f301, 'f301_lowdose_full_traces', '-dpng','-r300')

% % See note on rastergram plotting in the first plotting script
% f302 = dsPlot(data_3_lowdose, 'plot_type', 'rastergram',...
%     'disregard_analysis_calc',1);
% print(f302, 'f302_lowdose_full_raster', '-dpng','-r300')

% f303 = dsPlot(data_3_lowdose, 'plot_type', 'power','xlim',[0 80],...
%         'disregard_analysis_calc',1);
% print(f303, 'f303_lowdose_full_power', '-dpng','-r300')

%% Trough-max subrange
% Plot the first trough-max cycles of the simulation
time_index_begin =   3001; % In milliseconds
time_index_end =     6000; % In milliseconds
time_index_range = round(time_index_begin/(dt*downsample_factor)):round(time_index_end/(dt*downsample_factor));

f304 = figure('Color', 'w', 'Units', 'normalized', 'InnerPosition', [0, 0, 1, 1]);
ax1=subplot(5,1,1); plot(time(time_index_range),data_3_lowdose.PYdr_v(time_index_range,neuron),'LineWidth',1,'color','k'); ylim([-100 50]); set(ax1,'XTickLabel',{},'YTickLabel',{},'box','off')
ax2=subplot(5,1,2); plot(time(time_index_range),data_3_lowdose.PYso_v(time_index_range,neuron),'LineWidth',1,'color','k'); ylim([-100 50]); set(ax2,'XTickLabel',{},'YTickLabel',{},'box','off')
ax3=subplot(5,1,3); plot(time(time_index_range),data_3_lowdose.IN_v(time_index_range,neuron),  'LineWidth',1,'color','k'); ylim([-100 50]); set(ax3,'XTickLabel',{},'YTickLabel',{},'box','off')
ax4=subplot(5,1,4); plot(time(time_index_range),data_3_lowdose.TC_v(time_index_range,neuron),  'LineWidth',1,'color','k'); ylim([-100 50]); set(ax4,'XTickLabel',{},'YTickLabel',{},'box','off')
ax5=subplot(5,1,5); plot(time(time_index_range),data_3_lowdose.TRN_v(time_index_range,neuron), 'LineWidth',1,'color','k'); ylim([-100 50]); set(ax5,'XTickLabel',{},'YTickLabel',{},'box','off')
print(f304, 'f304_lowdose_tmax_traces', '-dpng','-r300')

% Plot the tmax TCPY and PYPY relevant traces, mean IAMPA currents, and
% those currents' spectra (our EEG signals)
f305 = figure('Color', 'w', 'Units', 'normalized', 'InnerPosition', [0, 0, 1, 1]);
ax1=subplot(3,2,1);
plot(time(time_index_range),data_3_lowdose.PYdr_v(time_index_range,neuron),'LineWidth',1.5,'color','k'); ylim([-100 50]); set(ax1,'XTickLabel',{},'YTickLabel',{},'box','off')
ax2=subplot(3,2,2);
plot(time(time_index_range),data_3_lowdose.PYdr_v(time_index_range,neuron),'LineWidth',1.5,'color','k'); ylim([-100 50]); set(ax2,'XTickLabel',{},'YTickLabel',{},'box','off')
ax3=subplot(3,2,3);
plot(time(time_index_range),data_3_lowdose.TC_v(time_index_range,neuron),  'LineWidth',1.5,'color','k'); ylim([-100 50]); set(ax3,'XTickLabel',{},'YTickLabel',{},'box','off')
% NEIGHBORing PYso
ax4=subplot(3,2,4);
plot(time(time_index_range),data_3_lowdose.PYso_v(time_index_range,neuron+1),'LineWidth',1.5,'color','k'); ylim([-100 50]); set(ax4,'XTickLabel',{},'YTickLabel',{},'box','off')
ax5=subplot(3,2,5);
plot(time(time_index_range),mean(data_3_lowdose.PYdr_TC_iAMPA_PYdr_TC_iAMPA_PYdr_TC(time_index_range,:),2),'LineWidth',1.5,'color','k'); set(ax5,'XTickLabel',{},'box','off')
ax6=subplot(3,2,6);
plot(time(time_index_range),mean(data_3_lowdose.PYdr_PYso_iAMPA_PYdr_PYso_JB12_IAMPA_PYdr_PYso_JB12(time_index_range,:),2),'LineWidth',1.5,'color','k'); set(ax6,'XTickLabel',{},'box','off')
print(f305, 'f305_lowdose_tmax_iampa', '-dpng','-r300')

% Plot the tmax subrange comodulograms
%
% TCPY comodulograms
%
% The filters used for the comodulograms are centered around the Cartesian
% product of {9, 12} Hz for alpha and {0.01, 1.01, 2.01} Hz for SWO.
current_data = data_3_lowdose.PYdr_TC_iAMPA_PYdr_TC_iAMPA_PYdr_TC_Comodulograms_MUA.comodulograms;
% 'smaller_data' is for using only a subset of the original comodulogram
% data, since the initial transient of the simulation (the first few
% seconds) takes time to adapt to the steady-state of the simulation.
smaller_data = cell(size(current_data));

f306 = figure('Color', 'w', 'Units', 'normalized', 'InnerPosition', [0, 0, 1, 1]);
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
print(f306, 'f306_lowdose_tmax_tcpy_comodulograms', '-dpng','-r300')

% PYPY comodulograms
current_data = data_3_lowdose.PYdr_PYso_iAMPA_PYdr_PYso_JB12_IAMPA_PYdr_PYso_JB12_Comodulogra.comodulograms;
smaller_data = cell(size(current_data));

f307 = figure('Color', 'w', 'Units', 'normalized', 'InnerPosition', [0, 0, 1, 1]);
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
print(f307, 'f307_lowdose_tmax_pypy_comodulograms', '-dpng','-r300')


%% Peak-max subrange
% Plot ONLY a subset of peak-max cycles of the simulation
time_index_begin =   10001; % In milliseconds
time_index_end =     14000; % In milliseconds
neuron = 10;
time_index_range = round(time_index_begin/(dt*downsample_factor)):round(time_index_end/(dt*downsample_factor));

f308 = figure('Color', 'w', 'Units', 'normalized', 'InnerPosition', [0, 0, 1, 1]);
ax1=subplot(5,1,1); plot(time(time_index_range),data_3_lowdose.PYdr_v(time_index_range,neuron),'LineWidth',1,'color','k'); ylim([-100 50]); set(ax1,'XTickLabel',{},'YTickLabel',{},'box','off')
ax2=subplot(5,1,2); plot(time(time_index_range),data_3_lowdose.PYso_v(time_index_range,neuron),'LineWidth',1,'color','k'); ylim([-100 50]); set(ax2,'XTickLabel',{},'YTickLabel',{},'box','off')
ax3=subplot(5,1,3); plot(time(time_index_range),data_3_lowdose.IN_v(time_index_range,neuron),  'LineWidth',1,'color','k'); ylim([-100 50]); set(ax3,'XTickLabel',{},'YTickLabel',{},'box','off')
ax4=subplot(5,1,4); plot(time(time_index_range),data_3_lowdose.TC_v(time_index_range,neuron),  'LineWidth',1,'color','k'); ylim([-100 50]); set(ax4,'XTickLabel',{},'YTickLabel',{},'box','off')
ax5=subplot(5,1,5); plot(time(time_index_range),data_3_lowdose.TRN_v(time_index_range,neuron), 'LineWidth',1,'color','k'); ylim([-100 50]); set(ax5,'XTickLabel',{},'YTickLabel',{},'box','off')
print(f308, 'f308_lowdose_pmax_traces', '-dpng','-r300')

% Plot the pmax TCPY and PYPY relevant traces, mean IAMPA currents, and
% those currents' spectra (our EEG signals)
f309 = figure('Color', 'w', 'Units', 'normalized', 'InnerPosition', [0, 0, 1, 1]);
ax1=subplot(3,2,1);
plot(time(time_index_range),data_3_lowdose.PYdr_v(time_index_range,neuron),'LineWidth',1.5,'color','k'); ylim([-100 50]); set(ax1,'XTickLabel',{},'YTickLabel',{},'box','off')
ax2=subplot(3,2,2);
plot(time(time_index_range),data_3_lowdose.PYdr_v(time_index_range,neuron),'LineWidth',1.5,'color','k'); ylim([-100 50]); set(ax2,'XTickLabel',{},'YTickLabel',{},'box','off')
ax3=subplot(3,2,3);
plot(time(time_index_range),data_3_lowdose.TC_v(time_index_range,neuron),  'LineWidth',1.5,'color','k'); ylim([-100 50]); set(ax3,'XTickLabel',{},'YTickLabel',{},'box','off')
% NEIGHBORing PYso
ax4=subplot(3,2,4);
plot(time(time_index_range),data_3_lowdose.PYso_v(time_index_range,neuron+1),'LineWidth',1.5,'color','k'); ylim([-100 50]); set(ax4,'XTickLabel',{},'YTickLabel',{},'box','off')
ax5=subplot(3,2,5);
plot(time(time_index_range),mean(data_3_lowdose.PYdr_TC_iAMPA_PYdr_TC_iAMPA_PYdr_TC(time_index_range,:),2),'LineWidth',1.5,'color','k'); set(ax5,'XTickLabel',{},'box','off')
ax6=subplot(3,2,6);
plot(time(time_index_range),mean(data_3_lowdose.PYdr_PYso_iAMPA_PYdr_PYso_JB12_IAMPA_PYdr_PYso_JB12(time_index_range,:),2),'LineWidth',1.5,'color','k'); set(ax6,'XTickLabel',{},'box','off')
print(f309, 'f309_lowdose_pmax_iampa', '-dpng','-r300')

% Plot the pmax subrange comodulograms
%
% TCPY comodulograms
%
% The filters used for the comodulograms are centered around the Cartesian
% product of {9, 12} Hz for alpha and {0.01, 1.01, 2.01} Hz for SWO.
current_data = data_3_lowdose.PYdr_TC_iAMPA_PYdr_TC_iAMPA_PYdr_TC_Comodulograms_MUA.comodulograms;
% 'smaller_data' is for using only a subset of the original comodulogram
% data, since the initial transient of the simulation (the first few
% seconds) takes time to adapt to the steady-state of the simulation.
smaller_data = cell(size(current_data));

f310 = figure('Color', 'w', 'Units', 'normalized', 'InnerPosition', [0, 0, 1, 1]);
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
print(f310, 'f310_lowdose_pmax_tcpy_comodulograms', '-dpng','-r300')

% PYPY comodulograms
current_data = data_3_lowdose.PYdr_PYso_iAMPA_PYdr_PYso_JB12_IAMPA_PYdr_PYso_JB12_Comodulogra.comodulograms;
smaller_data = cell(size(current_data));

f311 = figure('Color', 'w', 'Units', 'normalized', 'InnerPosition', [0, 0, 1, 1]);
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
print(f311, 'f311_lowdose_pmax_pypy_comodulograms', '-dpng','-r300')

%% PYTC currents
% Plot ONLY the first trough-max cycles of the simulation
time_index_begin =   3001; % In milliseconds
time_index_end =     6000; % In milliseconds
neuron = 5;
time_index_range = round(time_index_begin/(dt*downsample_factor)):round(time_index_end/(dt*downsample_factor));

yRange = [-1 4];

% Plot the tmax PYTC relevant traces, mean IAMPA currents, and
% those currents' spectra (our EEG signals)
f312 = figure('Color', 'w', 'Units', 'normalized', 'InnerPosition', [0, 0, 1, 1]);
ax1=subplot(2,1,1);
plot(time(time_index_range),mean(data_3_lowdose.TC_PYso_iAMPA_TC_PYso_iAMPA_TC_PYso(time_index_range,:),2),'LineWidth',1,'color','k'); set(ax1,'XTickLabel',{},'box','off')
ylim(yRange);

% Plot ONLY a subset of peak-max cycles of the simulation
time_index_begin =   10001; % In milliseconds
time_index_end =     14000; % In milliseconds
neuron = 5;
time_index_range = round(time_index_begin/(dt*downsample_factor)):round(time_index_end/(dt*downsample_factor));

% Plot the tmax PYTC relevant traces, mean IAMPA currents, and
% those currents' spectra (our EEG signals)
ax2=subplot(2,1,2);
plot(time(time_index_range),mean(data_3_lowdose.TC_PYso_iAMPA_TC_PYso_iAMPA_TC_PYso(time_index_range,:),2),'LineWidth',1,'color','k'); set(ax2,'XTickLabel',{},'box','off')
ylim(yRange);

print(f312, 'f312_lowdose_pytc_iampas_both', '-dpng','-r300')


% % Remove the dataset from RAM to free up space
% clear data_3_lowdose


%{
Load and plot the first dataset data_sim1_wake.mat corresponding to an
"awake" simulation, so that figures may be assembled from these plots
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

%% Part 1: Plotting wake/no-propofol case
if ~exist('data_sim1_wake','var')
%     load(strcat(output_dir,'data_p25d1w2s110sim1_20210517_wake_base0pt004.mat'))
    load(strcat(output_dir,'data_1_relay.mat'))
end

time = data_sim1_wake.time;
dt = 0.01; % Time resolution of simulation, set in each sim file
downsample_factor = 10; % Set in each sim file
time_index_begin = 2001; % In milliseconds
time_index_end =   3000; % In milliseconds
sampling_factor = 1 / (dt*downsample_factor / 1000);

time_index_range = round(time_index_begin/(dt*downsample_factor)):round(time_index_end/(dt*downsample_factor));

f101 = figure('Color', 'w', 'Units', 'normalized', 'InnerPosition', [0, 0, 1, 1]);
ax1=subplot(5,1,1); plot(time(time_index_range),data_sim1_wake.PYdr_v(time_index_range,1),'LineWidth',1.5, 'color', 'k'); ylim([-100 50]); set(ax1,'XTickLabel',{},'YTickLabel',{},'box','off')
ax2=subplot(5,1,2); plot(time(time_index_range),data_sim1_wake.PYso_v(time_index_range,1),'LineWidth',1.5, 'color', 'k'); ylim([-100 50]); set(ax2,'XTickLabel',{},'YTickLabel',{},'box','off')
ax3=subplot(5,1,3); plot(time(time_index_range),data_sim1_wake.IN_v(time_index_range,1),  'LineWidth',1.5, 'color', 'k'); ylim([-100 50]); set(ax3,'XTickLabel',{},'YTickLabel',{},'box','off')
ax4=subplot(5,1,4); plot(time(time_index_range),data_sim1_wake.TC_v(time_index_range,1),  'LineWidth',1.5, 'color', 'k'); ylim([-100 50]); set(ax4,'XTickLabel',{},'YTickLabel',{},'box','off')
ax5=subplot(5,1,5); plot(time(time_index_range),data_sim1_wake.TRN_v(time_index_range,1), 'LineWidth',1.5, 'color', 'k'); ylim([-100 50]); set(ax5,'XTickLabel',{},'YTickLabel',{},'box','off')
print(f101, 'f101_wake_traces', '-dpng','-r300')

% % If you want rastergram plots, I recommend using the images that
% % the simulation produces itself (in their "<output
% % directory>/plots") rather than replotting the rastergrams, since
% % the below can take several minutes to generate the plot and can
% % use a lot of memory.
% %
% % This plot in particular may require 32GB of RAM due to the amount of
% % spikes
% f102 = dsPlot(data_sim1_wake, 'plot_type', 'rastergram',...
%               'disregard_analysis_calc',1);
% print(f102, 'f102_wake_raster', '-dpng','-r300')

% % If want awake sim power
% f103 = dsPlot(data_sim1_wake, 'plot_type', 'power',...
%     'disregard_analysis_calc',1,...
%     'xlim',[0 80]);
% print(f103, 'f103_wake_power', '-dpng')

f104 = figure('Color', 'w', 'Units', 'normalized', 'InnerPosition', [0, 0, 1, 1]);
neuron = 1;
ax1=subplot(3,1,1); plot(time(time_index_range),data_sim1_wake.TC_v(time_index_range,neuron),  'LineWidth',1,'color','k'); ylim([-100 50]); set(ax1,'box','off')
ax2=subplot(3,1,2); plot(time(time_index_range),data_sim1_wake.TC_v(time_index_range,neuron),  'LineWidth',1,'color','k'); ylim([-80 -40]); set(ax2,'box','off')
ax3=subplot(3,1,3); plot(time(time_index_range),data_sim1_wake.TC_iT_TC_AS17_hT(time_index_range,neuron),  'LineWidth',1,'color','k'); ylim([0 0.25]); set(ax3,'box','off')
print(f104, 'f104_wake_tc_threshold', '-dpng','-r300')

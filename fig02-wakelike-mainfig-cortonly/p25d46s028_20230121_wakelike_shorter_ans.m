%{
%}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Load data
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

sim_name = 'p25d46s028_20230121_wakelike_shorter_i001';

if ~exist('data','var')
    data = load(strcat('/example-output-directory/x7-scc-data/p25-thalcort-data/',...
                       sim_name,...
                       '/data/study_sim1_data.mat'));
end

%% Calc and simply print spikerates

% in ms
time_begin =   5000;
% time_end =    30000;
time_end =    10000;
time_index_range = time_begin*10+1:time_end*10;

N_PYdr = 100;
N_TC = 20;
N_TRN = 20;

% Will have to convert to get these in spikes/second
single_PYdr_spikerates = zeros(N_PYdr, 1);
single_TC_spikerates = zeros(N_TC, 1);
single_TRN_spikerates = zeros(N_TRN, 1);

for ii = 1:N_PYdr
  single_PYdr_spikerates(ii) = sum(data.PYdr_v_spikes(time_index_range, ii)) / ...
                               ((time_end - time_begin)/1000);
end

for ii = 1:N_TC
  single_TC_spikerates(ii) = sum(data.TC_v_spikes(time_index_range, ii)) / ...
                             ((time_end - time_begin)/1000);
end

for ii = 1:N_TRN
  single_TRN_spikerates(ii) = sum(data.TRN_v_spikes(time_index_range, ii)) / ...
                             ((time_end - time_begin)/1000);
end

global_PYdr_spikerate = mean(single_PYdr_spikerates)
global_TC_spikerate = mean(single_TC_spikerates)
global_TRN_spikerate = mean(single_TRN_spikerates)


%% Plot power

args.sim_name = sim_name;

% Set the time ranges for the different PAC types
args.time_begin = time_begin;
args.time_end =   time_end;

% Other params
args.downsampling_factor = 10;

% plot config
args.smooth_factor = 5;
% args.power_height =  6.0;
args.max_freq_plot = 50;

single_unfiltered_spectrum(data, args)

%% Plot homemade rastergram ugh

% Manually increasing size of PY spikes due to less time
fraster = figure(10);
fraster.WindowState = 'maximized';
ha = tight_subplot(5,1,[.02 .03],[.01 .01],[.01 .01]);
axes(ha(1)); spy(data.PYdr_v_spikes(time_index_range,:)', '.k',  5); pbaspect auto; ha(1).XLabel.String = '';
axes(ha(2)); spy(data.PYso_v_spikes(time_index_range,:)', '.k',  5); pbaspect auto; ha(2).XLabel.String = '';
axes(ha(3)); spy(data.IN_v_spikes(time_index_range,:)',   '|k',  7); pbaspect auto; ha(3).XLabel.String = '';
axes(ha(4)); spy(data.TC_v_spikes(time_index_range,:)',   '|k',  7); pbaspect auto; ha(4).XLabel.String = '';
axes(ha(5)); spy(data.TRN_v_spikes(time_index_range,:)',  '|k',  7); pbaspect auto; ha(5).XLabel.String = '';
set(ha(1:5),'XTickLabel',''); set(ha,'YTickLabel','')

print(fraster, strcat(sim_name, '_homemade_raster'), '-dpng', '-r600')


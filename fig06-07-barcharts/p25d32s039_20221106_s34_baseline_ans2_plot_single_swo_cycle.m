%{
%}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Load data
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% sim_name = 'p25d32s021_20221029_baseline_s7_cpu_i001';
% sim_name = 'p25d32s038_20221106_s30_baseline_i001';
sim_name = 'p25d32s039_20221106_s34_baseline_i001';

if ~exist('data','var')
    data = load(strcat('/example-output-directory/x7-scc-data/p25-thalcort-data/',...
                       sim_name,...
                       '/data/study_sim1_data.mat'));
end

time_begin =  1;
time_end =    10000;
time_index_range = time_begin*10+1:time_end*10;
nn = 0;
do_plots = 1;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Compute and save Butterworth-Hilbert SWO phase bin info
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Actual Summed Isyns
% 
% summed_isyns = sum(data.PYdr_PYso_iAMPA_PYdr_PYso_JB12_IAMPA_PYdr_PYso_JB12(time_index_range,:), 2) + ...
%     sum(data.PYdr_TC_iAMPA_PYdr_TC_IAMPA_PYdr_TC(time_index_range,:), 2);
summed_isyns = sum(data.PYdr_PYso_iAMPA_PYdr_PYso_JB12_IAMPA_PYdr_PYso_JB12, 2) + ...
    sum(data.PYdr_TC_iAMPA_PYdr_TC_IAMPA_PYdr_TC, 2);



detrended_isyns = detrend(summed_isyns);
if isvector(detrended_isyns)
  detrended_isyns = detrended_isyns(:);
end

%% Other ans params
Fs = 1000*10;
nyq = Fs/2;

phase_filter_freqs_bh = [0.5 2.0];
ampl_filter_freqs_bh  = [8 14];
phase_filter_order_bh = 2;
ampl_filter_order_bh  = 2;

calc_comodulogramsBH = 1;

fprintf('About to start running phase-amplitude coupling / comodulogram analysis\n')

% Filtering %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Each cell array element of ph_filt_signals and filt_amp_sig has the
% same dimensions as the original signals i.e. number of columns = number of
% trials
fprintf('About to begin filtering signals\n')
[filt_ph_sig, filt_amp_sig] = filt_signals_butter(detrended_isyns, detrended_isyns, Fs,...
  phase_filter_freqs_bh, ampl_filter_freqs_bh,...
  phase_filter_order_bh, ampl_filter_order_bh);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Calculate PAC measures %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
fprintf('About to analyze filtered signals\n')
[pacmat, pac_angles, comodulogramsBH, modulation_indices] = find_pac_nofilt_bh(...
  filt_ph_sig, filt_amp_sig, Fs, calc_comodulogramsBH);

swo_phases_bh = angle(hilbert(filt_ph_sig{1,1}));

%% Plot simple example of Butterworth-Hilbert SWO ampl and phase trace

% time for SINGLE example
time_begin =  2700;
time_end =    4000;

time_index_range = time_begin*10+1:time_end*10;

if do_plots==1
    nn = nn + 1;
    h(nn) = figure(nn);
    subplot(311)
    plot(data.time(time_index_range), detrended_isyns(time_index_range))
    subplot 312
    plot(data.time(time_index_range), filt_ph_sig{1,1}(time_index_range),'k')
    subplot 313
    plot(data.time(time_index_range), swo_phases_bh(time_index_range), 'k')
end

print(h(nn), strcat(sim_name, '_plot_single_swo_cycle'), '-dpng')
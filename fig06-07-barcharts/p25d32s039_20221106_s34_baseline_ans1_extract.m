%{
%}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Load data
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% sim_name = 'p25d32s021_20221029_baseline_s7_cpu_i001';
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
%% Compute and save WAVELET SWO phase bin info
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Actual Summed Isyns


summed_isyns = sum(data.PYdr_PYso_iAMPA_PYdr_PYso_JB12_IAMPA_PYdr_PYso_JB12(time_index_range,:), 2) + ...
    sum(data.PYdr_TC_iAMPA_PYdr_TC_IAMPA_PYdr_TC(time_index_range,:), 2);
fs = 1000*10;
nyq = fs/2;

detrended_isyns = detrend(summed_isyns);

sig1 = detrended_isyns;
sig2 = detrended_isyns;
% sig1 = summed_isyns;
% sig2 = summed_isyns;
Fs = 1000*10;
ph_freq_vec = [0.5:0.5:2.0];
amp_freq_vec = [8:3:20];
% amp_freq_vec = [8:3:14];
% ph_freq_vec = [0.5 2.0];
% amp_freq_vec = [8 14];
measure = 'mi';
% width = 3;
width = 7;
% width = 11;

[ph_filt_signals, amp_filt_signals] = filt_signalsWAV(sig1,sig2,...
    Fs, ph_freq_vec, amp_freq_vec, measure, width);

ph_freq_vec = [0.5:0.5:2.0];
% hacked to get SWO amplitude
[ph_filt_signals, slow_amp_filt_signals] = filt_signalsWAV(sig1,sig2,...
    Fs, ph_freq_vec, ph_freq_vec, measure, width);

if do_plots==1
    nn = nn + 1;
    figure(nn)
    subplot(411)
    plot(sig1)
    for ii = 1:length(ph_filt_signals)
        subplot(411+ii)
        plot(ph_filt_signals{1,ii},'k')
    end

    nn = nn + 1;
    figure(nn)
    subplot(511)
    plot(sig1)
    for ii = 1:length(amp_filt_signals)
        subplot(511+ii)
        plot(amp_filt_signals{1,ii},'r')
    end

    nn = nn + 1;
    figure(nn)
    subplot(411)
    plot(sig1)
    for ii = 1:length(slow_amp_filt_signals)
        subplot(411+ii)
        plot(slow_amp_filt_signals{1,ii},'r')
    end


    nn = nn + 1;
    figure(nn)
    subplot(411)
    plot(sig1)
    for ii = 1:length(ph_filt_signals)
        subplot(411+ii)
        plot(ph_filt_signals{1,ii},'r')
    end
end

%% Extract SWO phase bin at beginning of every 100 ms time bin

samples_per_msec = 10;

binned_swo_ph = ph_filt_signals{1,2}(1000*samples_per_msec:100*samples_per_msec:9800*samples_per_msec);

writematrix(binned_swo_ph, strcat(sim_name, '_swo_ph_data.csv'))

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Compute and save Butterworth-Hilbert SWO phase bin info
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Actual Summed Isyns

summed_isyns = sum(data.PYdr_PYso_iAMPA_PYdr_PYso_JB12_IAMPA_PYdr_PYso_JB12(time_index_range,:), 2) + ...
    sum(data.PYdr_TC_iAMPA_PYdr_TC_IAMPA_PYdr_TC(time_index_range,:), 2);

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

if do_plots==1
    nn = nn + 1;
    figure(nn)
    subplot(311)
    plot(detrended_isyns)
    subplot 312
    plot(filt_ph_sig{1,1},'k')
    subplot 313
    plot(swo_phases_bh, 'k')

    nn = nn + 1;
    figure(nn)
    subplot 211
    plot(detrended_isyns)
    subplot 212
    plot(filt_amp_sig{1,1},'r')

    nn = nn + 1;
    h1 = figure(nn);
    subplot(411)
    spy(data.PYso_v_spikes(time_index_range,:)'); pbaspect auto
    title('PYso spikes')
    subplot(412)
    spy(data.TC_v_spikes(time_index_range,:)'); pbaspect auto
    title('TC spikes')
    subplot(413)
    plot(detrended_isyns)
    title('LFP / Combined Exc Syn currents')
    subplot(414)
    plot(filt_ph_sig{1,1})
    hold on
    plot(filt_amp_sig{1,1}./10000,'r')
    hold off
    title('ALPHA (12.5 Hz) amplitude across SWO phase')

    fprintf('NOT SAVED since just script for extraction')
    % print(h1, strcat(sim_name, '_slow_ph'), '-dpng')
end


%% Extract SWO phase bin at beginning of every 100 ms time bin

samples_per_msec = 10;

binned_swo_ph = swo_phases_bh(1000*samples_per_msec:100*samples_per_msec:9800*samples_per_msec);

writematrix(binned_swo_ph, strcat(sim_name, '_BUTTER_swo_ph_data.csv'))

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Extract simple example of Butterworth-Hilbert SWO ampl and phase trace
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% time for SINGLE example
time_begin =  1700;
time_end =    2500;
time_index_range = time_begin*10+1:time_end*10;

if do_plots==1
    nn = nn + 1;
    figure(nn)
    subplot(311)
    plot(data.time(time_index_range), detrended_isyns(time_index_range))
    subplot 312
    plot(data.time(time_index_range), filt_ph_sig{1,1}(time_index_range),'k')
    subplot 313
    plot(data.time(time_index_range), swo_phases_bh(time_index_range), 'k')
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Extract MEAN TC gH P1 at beginning of every 100 ms time bin
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

samples_per_msec = 10;

binned_tc_gh_p1_data = mean(data.TC_iH_TC_AS17_Pone(1000*samples_per_msec:100*samples_per_msec:9800*samples_per_msec,:), 2);

writematrix(binned_tc_gh_p1_data, strcat(sim_name, '_tc_p1_data.csv'))


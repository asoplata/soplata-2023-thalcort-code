%{
Load and plot the second dataset full_sim.mat corresponding
to a simulation with only the direct effects of propofol applied, so
that figures may be assembled from these plots using Inkscape.

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

%% Part 2: Plotting direct-effects-only propofol case
if ~exist('full_sim','var')
%     load(strcat(output_dir,'data_p25d1w2s110sim2_20210517_directonly_base0pt004_sim1.mat'))
    load(strcat(output_dir,'data_2_directonly.mat'))
end

% Just to be comprehensive, SWO freq filters were used for a very wide
% range of frequencies, even so low as "one frequency's trough (e.g. 0.5
% Hz) can be another's peak (e.g. 0.2 Hz)". This is the minimum index to
% use for evaluating the different frequency filters, where index 1
% corresponds to including the frequency filtered centered (as much as
% possible, anyways) around 0.01 Hz, index 2 = 0.21 Hz, 3 = 0.41 Hz, 4 =
% 0.61 Hz, etc. All analyses of 0.01 Hz yields NaN / invalid data since not
% all phases of a single cycle are detected. "Infra-slow" oscillations may
% not be applicable since propofol SWO is usually higher in frequency, and
% the "peak" of infra-slow oscillations is going to include both the peak
% and trough of faster SWO oscillations e.g. > 0.5 Hz. Index 4 = 0.61 Hz is
% the first analysis done above the normal SWO cutoff of 0.5 Hz so let's
% start with that. 
min_swo_freq_plotted = 4;

% Choose the portion of the all the time series to display to better
% illustrate the simulation
time = full_sim.time;
dt = 0.01; % Time resolution of simulation, set in each sim file
downsample_factor = 10; % Set in each sim file
time_index_begin = 2001; % In milliseconds
time_index_end =   3000; % In milliseconds
sampling_factor = 1 / (dt*downsample_factor / 1000);
neuron = 11;

time_index_range = round(time_index_begin/(dt*downsample_factor)):round(time_index_end/(dt*downsample_factor));

% Plot the basic cell voltage traces, rastergram, and power spectra
f201 = figure('Color', 'w', 'Units', 'normalized', 'InnerPosition', [0, 0, 1, 1]);
ax1=subplot(5,1,1); plot(time(time_index_range),full_sim.PYdr_v(time_index_range,neuron),'LineWidth',1.5, 'color', 'k'); ylim([-100 50]); set(ax1,'XTickLabel',{},'YTickLabel',{},'box','off')
ax2=subplot(5,1,2); plot(time(time_index_range),full_sim.PYso_v(time_index_range,neuron),'LineWidth',1.5, 'color', 'k'); ylim([-100 50]); set(ax2,'XTickLabel',{},'YTickLabel',{},'box','off')
ax3=subplot(5,1,3); plot(time(time_index_range),full_sim.IN_v(time_index_range,neuron),  'LineWidth',1.5, 'color', 'k'); ylim([-100 50]); set(ax3,'XTickLabel',{},'YTickLabel',{},'box','off')
ax4=subplot(5,1,4); plot(time(time_index_range),full_sim.TC_v(time_index_range,neuron),  'LineWidth',1.5, 'color', 'k'); ylim([-100 50]); set(ax4,'XTickLabel',{},'YTickLabel',{},'box','off')
ax5=subplot(5,1,5); plot(time(time_index_range),full_sim.TRN_v(time_index_range,neuron), 'LineWidth',1.5, 'color', 'k'); ylim([-100 50]); set(ax5,'XTickLabel',{},'YTickLabel',{},'box','off')
print(f201, 'f201_direct_only_traces', '-dpng','-r300')

% % See note on rastergram plotting in the first plotting script
% f202 = dsPlot(full_sim, 'plot_type', 'rastergram',...
%     'disregard_analysis_calc',1);
% print(f202, 'f202_direct_only_raster', '-dpng','-r300')
%
% f203 = dsPlot(full_sim, 'plot_type', 'power','xlim',[0 80],...
%         'disregard_analysis_calc',1);
% print(f203, 'f203_direct_only_power', '-dpng','-r300')

f204 = figure('Color', 'w', 'Units', 'normalized', 'InnerPosition', [0, 0, 1, 1]);
neuron = 1;
ax1=subplot(3,1,1); plot(time(time_index_range),full_sim.TC_v(time_index_range,neuron),  'LineWidth',1,'color','k'); ylim([-100 50]); set(ax1,'box','off')
ax2=subplot(3,1,2); plot(time(time_index_range),full_sim.TC_v(time_index_range,neuron),  'LineWidth',1,'color','k'); ylim([-80 -40]); set(ax2,'box','off')
ax3=subplot(3,1,3); plot(time(time_index_range),full_sim.TC_iT_TC_AS17_hT(time_index_range,neuron),  'LineWidth',1,'color','k'); ylim([0 0.25]); set(ax3,'box','off')
print(f204, 'f204_direct_only_tc_threshold', '-dpng','-r300')


% take whole simulation except for initial transient
time_index_begin = 1000; % In milliseconds
time_index_end =   4000; % In milliseconds
time_index_range = round(time_index_begin/(dt*downsample_factor)):round(time_index_end/(dt*downsample_factor));


total_lfp = sum(full_sim.PYdr_TC_iAMPA_PYdr_TC_iAMPA_PYdr_TC(time_index_range,:),2) + ...
    sum(full_sim.PYdr_PYso_iAMPA_PYdr_PYso_JB12_IAMPA_PYdr_PYso_JB12(time_index_range,:),2);

f205 = figure('Color', 'w', 'Units', 'normalized', 'InnerPosition', [0, 0, 1, 1]);
plot(time_index_range, total_lfp)

print(f205, 'f205_direct_only_total_lfp', '-dpng','-r300')

total_lfp = detrend(total_lfp);


nfft = 2^(round(log2(length(total_lfp))));

% Get spectrum
[pxx,f] = pwelch(total_lfp,0.25*sampling_factor,[],nfft,sampling_factor);
% [pxx,f] = pwelch(mean(full_sim.PYdr_v,2),1*sampling_factor,[],nfft,sampling_factor);
converted_pxx = 10*log10(pxx);

% Only interested in up to 100 Hz, and 5 kHz is our Nyquist frequency, so
relevant_max_frequency = 100;
relevant_max_index = round(relevant_max_frequency/(sampling_factor/2) * length(f));




f206 = figure('Color', 'w', 'Units', 'normalized', 'InnerPosition', [0, 0, 1, 1]);
plot(f(1:relevant_max_index),converted_pxx(1:relevant_max_index))

% [s,f,t] = spectrogram(total_lfp,0.25*sampling_factor,0.05*sampling_factor,nfft,sampling_factor,'yaxis');
% 
% % Only interested in up to 150 Hz, and 5 kHz is our Nyquist frequency, so
% relevant_max_frequency = 100;
% 
% relevant_max_index = round(relevant_max_frequency/(sampling_factor/2) * length(f));
% 
% converted_s = 10*log10(abs(s)+eps);
% 
% ax1=imagesc(t,f(1:relevant_max_index),converted_s(1:relevant_max_index,:));


print(f206, 'f206_direct_only_total_lfp_spect', '-dpng','-r300')


%% Also compare to PYdr V spect just in case
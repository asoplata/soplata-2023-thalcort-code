function single_unfiltered_spectrum_cortonly(data, args)

% Initialize plot index
nn = 0;

%% First, collect and detrend the data
% summed_isyns = sum(data.PYdr_PYso_iAMPA_PYdr_PYso_JB12_IAMPA_PYdr_PYso_JB12, 2) + ...
%     sum(data.PYdr_TC_iAMPA_PYdr_TC_IAMPA_PYdr_TC, 2);
summed_isyns = sum(data.PYdr_PYso_iAMPA_PYdr_PYso_JB12_IAMPA_PYdr_PYso_JB12, 2);

detrended_isyns = detrend(summed_isyns);

% timestep of simulations in ms
dt = 0.01;
% original sim uses time in ms, so we must convert to Hz
Fs = 1000 / (dt * args.downsampling_factor);

nn = nn + 1;
h(nn) = figure(nn);
%% Next, take the power spectrum of the time period

time_index_range = args.time_begin*args.downsampling_factor+1:args.time_end*args.downsampling_factor;

% swo_sig = filt_ph_sig(time_index_range);
sig = detrended_isyns(time_index_range);

NFFT = 2^(nextpow2(length(sig)-1)-1);
[Pxx_MUA, freqs] = pwelch(sig,NFFT,[],NFFT,Fs);
% AES TODO DEBUG
Pxx_MUA_smoothed = smooth(Pxx_MUA, args.smooth_factor);
% Pxx_MUA_smoothed = Pxx_MUA;

% subplot(3,2,[5 6])
plot(freqs, Pxx_MUA_smoothed, 'LineWidth', 2.0)
% semilogy(freqs, Pxx_MUA_smoothed)
xlim([0 args.max_freq_plot])
xlabel('freq (Hz)')
% ylim([0 args.power_height])
ylabel('power')
title(strcat('Power of time period ', num2str(args.time_begin), ...
    '-', num2str(args.time_end)))

print(h(nn), strcat(args.sim_name, '_Isyn_spectrum'), '-dpng')

end

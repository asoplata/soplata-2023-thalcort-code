

% Saves the data here
output_dir = strcat(pwd, '/');

% data_1_wake = combine_data_files(output_dir, 'sim_1_wake');
% save(strcat(output_dir,'data_1_wake.mat'), 'data_1_wake','-v7.3')
% clear data_1_wake

% data_2_direct_only = combine_data_files(output_dir, 'sim_2_direct_only');
% save(strcat(output_dir,'data_2_direct_only.mat'), 'data_2_direct_only','-v7.3')
% clear data_2_direct_only

data_3_lowdose = combine_data_files(output_dir, 'sim_3_lowdose');
save(strcat(output_dir,'data_3_lowdose.mat'), 'data_3_lowdose','-v7.3')
clear data_3_lowdose

% data_4_highdose = combine_data_files(output_dir, 'sim_4_highdose');
% save(strcat(output_dir,'data_4_highdose.mat'), 'data_4_highdose','-v7.3')
% clear data_4_highdose

% data_5_long_tmax = combine_data_files(output_dir, 'sim_5_long_tmax');
% save(strcat(output_dir,'data_5_long_tmax.mat'), 'data_5_long_tmax','-v7.3')
% clear data_5_long_tmax

% data_6_long_pmax = combine_data_files(output_dir, 'sim_6_long_pmax');
% save(strcat(output_dir,'data_6_long_pmax.mat'), 'data_6_long_pmax','-v7.3')
% clear data_6_long_pmax

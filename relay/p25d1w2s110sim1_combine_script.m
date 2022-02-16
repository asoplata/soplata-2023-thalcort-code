

% Saves the data here
input_dir = strcat('/YOUR_OUTPUT_DIR_HERE/')
output_dir = strcat(pwd, '/')

full_sim_name = 'p25d1w2s110sim1_20210517_wake_base0pt004'
vary_number = '1'
full_sim = combine_data(full_sim_name, vary_number, input_dir);
save(strcat(output_dir, 'data_', full_sim_name, '_sim', vary_number, '.mat'),...
    'full_sim' ,'-v7.3')
clear full_sim, full_sim_name

% full_sim_name = 'p25d1w2s110sim2_20210517_directonly_base0pt004'
% vary_number = '1'
% full_sim = combine_data(full_sim_name, vary_number, input_dir);
% save(strcat(output_dir, 'data_', full_sim_name, '_sim', vary_number, '.mat'),...
%     'full_sim' ,'-v7.3')
% clear full_sim, full_sim_name

% full_sim_name = 'p25d1w2s110sim34_20210517_syns_base0pt004'

% for ii = 1:16
%     vary_number = num2str(ii)
%     full_sim = combine_data(full_sim_name, vary_number, input_dir);
%     save(strcat(output_dir, 'data_', full_sim_name, '_sim', vary_number, '.mat'),...
%         'full_sim' ,'-v7.3')
%     clear full_sim
% end

% vary_number = '2'
% full_sim = combine_data(full_sim_name, vary_number, input_dir);
% save(strcat(output_dir, 'data_', full_sim_name, '_sim', vary_number, '.mat'),...
%     'full_sim' ,'-v7.3')
% clear full_sim
% 

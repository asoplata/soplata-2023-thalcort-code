%{
descended from p25d32s026...i030
%}

% -------------------------------------------------------------------
%% 0. Random seed wrapper
% -------------------------------------------------------------------
% % Use this block below for single sims with identical seed
% seed_list = 2222;
seed_list = 518667;

% % % Use this block below for many sims with different seeds
% % number_sims = 200;
% % number_sims = 30;
% number_sims = 10;
% % number_sims = 3;
% rng('shuffle')
% seed_list = randi(999999, number_sims, 1);

% Npop_PYdr = 100;
% appliedStim_distribution = rand(1, Npop_PYdr);

% 'PYdr',  'onset',  3900;
% 'PYdr',  'offset', 4000;


% -------------------------------------------------------------------
%% 1. Define simulation parameters
% -------------------------------------------------------------------
modifications  = {
'PYdr',  'appliedStimAmpl', 0.1;
'PYdr',  'randomFlag', 1;
'PYdr',  'onset',  2400;
'PYdr',  'offset', 2800;

'PYdr<-PYso', 'gAMPA', 0.004;
'PYdr<-TC',   'gAMPA', 0.004;
'PYdr',       'gext',  0.004;
'TC',         'gext',  0.004;
'TRN',        'gext',  0.004;

'PYdr', 'gLeak', 0.005;

'PYdr', 'baseline', 40.0;
'TC',   'baseline', 40.0;
'TRN',  'baseline', 40.0;
'PYdr', 'DC', 0.0;
'TC',   'DC', 0.0;
'TRN',  'DC', 0.0;

'PYdr<-PYso', 'gNMDA',  0.00257;
'IN<-PYso',   'gNMDA',  0.0025 ;

'PYso<-PYdr', 'gKNa',   1.33;
'IN<-PYso',   'gAMPA',  1.0;
'IN<-TC',     'gAMPA',  0.1;
'PYso<-IN',   'gGABAA', 0.1;
'TC',         'gH',     0.005;

'TRN',   'appliedStimAmpl', 0;
'TC',    'appliedStimAmpl', 0;

'PYso<-IN', 'propoCondMult', 3;
'PYso<-IN', 'propoTauMult',  3;
'IN<-IN',   'propoCondMult', 3;
'IN<-IN',   'propoTauMult',  3;
'TC<-TRN',  'propoCondMult', 3;
'TC<-TRN',  'propoTauMult',  3;
'TRN<-TRN', 'propoCondMult', 3;
'TRN<-TRN', 'propoTauMult',  3;
};


vary={...
    'PYdr',  'appliedStimAmpl', [0.5, 1.0, 2.0, 5.0];
    '(PYdr)',  '(onset, offset)',  [1000:100:9800 ; 1100:100:9900];
};

% Where the simulation output files (excluding data) will go.
output_dir = '/example-output-directory/x7-scc-data/p25-thalcort-data/';
% output_dir = '/example-output-directory/x7-scc-data/p25-thalcort-data/p025-thalcort-modeling/p25d1w3code-revisions/';


% This is where you set the length of your simulation
% time_end = 30000; % in milliseconds
% time_end = 15000; % in milliseconds
time_end = 10000; % in milliseconds
% time_end = 5000; % in milliseconds
% time_end = 4000; % in milliseconds
% time_end = 1000; % in milliseconds

% The time step/"resolution" used for the simulation. By default, DynaSim
% uses 0.01 milliseconds.
dt = 0.01; % in milliseconds

% Global scaling factor by which to multiple the number of cells in each
% population. The default scaling is 1, meaning 100 PYdr, 100 PYso, 20 IN,
% 20 TC, and 20 TRN. Changing the scale changes the population sizes
% proportionally, meaning a scaling of 0.5 would simulate a network using
% 50 PYdr, 50 PYso, 10 IN, 10 TC, and 10 TRN. Use this to decrease (< 1) or
% increase (> 1) the number of cells modeled in each population,
% proportionally.
numCellsScaleFactor = 1;
% numCellsScaleFactor = 0.2;


% default was 0.0667

% Options that affect the simulation properties without affecting the data;
% configuration rather than scientific options.

% -------------------------------------------------------------------
%% 2. Assemble and customize the model
% -------------------------------------------------------------------
spec = assembleFullSpec(numCellsScaleFactor);

% Apply local non-vary modifications to spec
spec = dsApplyModifications(spec, modifications);

iteration_number = 0;
for random_seed_index = 1:length(seed_list)

    iteration_number = iteration_number + 1;
    study_dir = strcat(output_dir, mfilename, '_i', num2str(iteration_number, '%.3d'));

    simulator_options={
    'cluster_flag', 1,...       % Whether to submit simulation jobs to a cluster, 0 or 1
    'cluster_matlab_version','2022a',...
    'compile_flag', 0,...       % Whether to compile simulation using MEX, 0 or 1
    'cpu_architecture', 'skylake',...
    'disk_flag', 0,...          % Not implemented, ignore
    'downsample_factor', 10,... % How much to downsample data, proportionally {integer}
    'dt', dt,...                % Fixed time step, in milliseconds
    'memory_limit', '64G',...   % Memory limit for use on cluster
    'mex_flag', 0,...           % Flag for MEX compilation, not recommended
    'num_cores', 4,...          % Number of CPU cores to use, including on cluster
    'overwrite_flag', 1,...     % Whether to overwrite simulation raw data, 0 or 1
    'parfor_flag', 0,...        % Whether to use parfor if running multiple local sims, 0 or 1
    'plot_functions', {@dsPlot, @dsPlot, @dsPlot, @dsPlot, @dsPlot,...
                       @dsPlot, @dsPlot, @dsPlot, @dsPlot, @dsPlot,...
                       @dsPlot, @dsPlot, @dsPlot},...
    'plot_options', {{'plot_type', 'waveform', 'format', 'png'},...   % Arguments to pass to each of those plot functions
                     {'plot_type', 'rastergram', 'format', 'png','plot_time_axis_sec_flag',0},...
                     {'plot_type', 'power', 'format', 'png'},...
                     {'plot_type', 'comodulogramsBH','format','png',...
                        'variable', 'PYdr_PYso_iAMPA_PYdr_PYso_JB12_IAMPA_PYdr_PYso_JB12',...
                        'max_num_rows',1},...
                     {'plot_type', 'comodulogramsBH','format','png',...
                        'variable', 'PYdr_TC_iAMPA_PYdr_TC_IAMPA_PYdr_TC',...
                        'max_num_rows',1},...
                     {'plot_type', 'comodulograms','format','png',...
                        'variable', 'PYdr_PYso_iAMPA_PYdr_PYso_JB12_IAMPA_PYdr_PYso_JB12',...
                        'max_num_rows',1},...
                     {'plot_type', 'comodulograms','format','png',...
                        'variable', 'PYdr_TC_iAMPA_PYdr_TC_IAMPA_PYdr_TC',...
                        'max_num_rows',1},...
                     {'plot_type', 'waveform', ...
                      'variable', {'TC_iH_TC_AS17_Open',...
                                   'TC_iH_TC_AS17_Pone',...
                                   'TC_iH_TC_AS17_OpenLocked',...
                                   'TC_iH_TC_AS17_iH_TC_AS17'}, ...
                      'max_num_rows', 4},...
                     {'plot_type', 'waveform', ...
                      'variable', {...
                                   'PYdr_PYso_iAMPA_PYdr_PYso_JB12_IAMPA_PYdr_PYso_JB12',...
                                   'PYdr_PYso_iAMPA_PYdr_PYso_JB12_res',...
                                  },...
                      'max_num_rows', 2},...
                     {'plot_type', 'power', ...
                      'variable', {...
                                   'PYdr_PYso_iAMPA_PYdr_PYso_JB12_IAMPA_PYdr_PYso_JB12',...
                                   'PYdr_PYso_iAMPA_PYdr_PYso_JB12_res',...
                                  },...
                      'max_num_rows', 2},...
                     {'plot_type', 'waveform', ...
                      'variable', {...
                                   'TC_PYso_iAMPA_TC_PYso_IAMPA_TC_PYso',...
                                   'TC_PYso_iAMPA_TC_PYso_sAMPA',...
                                  },...
                      'max_num_rows', 2},...
                     {'plot_type', 'waveform', ...
                      'variable', {...
                                   'PYdr_TC_iAMPA_PYdr_TC_IAMPA_PYdr_TC',...
                                   'PYdr_TC_iAMPA_PYdr_TC_sAMPA',...
                                  },...
                      'max_num_rows', 2},...
                     {'plot_type', 'power', ...
                      'variable', {...
                                   'PYdr_TC_iAMPA_PYdr_TC_IAMPA_PYdr_TC',...
                                   'PYdr_TC_iAMPA_PYdr_TC_sAMPA',...
                                  },...
                      'max_num_rows', 2},...
                    },...
   'random_seed', seed_list(random_seed_index),...     % What seed to use; use value 'shuffle' to randomize
    'save_data_flag', 0,...     % Whether to save raw output data, 0 or 1
    'save_results_flag', 1,...  % Whether to save output plots and analyses, 0 or 1
    'solver', 'euler',...       % Numerical integration method {'euler','rk1','rk2','rk4'}
    'study_dir', study_dir,...  % Where to save simulation results and code
    'tspan', [0 time_end],...   % Time vector of simulation, [beg end], in milliseconds
    'verbose_flag', 1,...       % Whether to display process info, 0 or 1
    };

    % -------------------------------------------------------------------
    %% 3. Run the simulation
    % -------------------------------------------------------------------
    data = dsSimulate(spec,'vary',vary,simulator_options{:});

    % pause(1)
end

% exit

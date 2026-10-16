function output_dir = setup_thalcort(subfolder)
%SETUP_THALCORT - Prepare MATLAB to run the (Soplata et al., 2023) scripts
%
% Every simulation and analysis script in this repository calls this
% function first. It:
%   1. Adds the bundled copy of DynaSim (`dynasim/`) and the model
%      (`model/`) to the MATLAB path, so nothing needs to be installed
%      separately.
%   2. Returns the directory where simulation results are saved and plots
%      are written, creating it (and any subfolder) if it doesn't exist.
%      The default location is:
%        - Mac/Linux: ~/soplata-thalcort-2023-output
%        - Windows:   %USERPROFILE%\soplata-thalcort-2023-output
%                     (the same folder as $HOME in PowerShell)
%
% Usage:
%   output_dir = setup_thalcort();          % top-level output directory
%   output_dir = setup_thalcort('fig03');   % ...or a subfolder of it
%
% To save output somewhere else, change `output_root` below.

repo_dir = fileparts(mfilename('fullpath'));

% Only add DynaSim to the path once per MATLAB session, since `genpath` over
% the whole toolbox is slow. This also makes sure the bundled DynaSim takes
% precedence over any other copy of DynaSim already on your path.
dynasim_dir = fullfile(repo_dir, 'dynasim');
if ~startsWith(which('dsSimulate'), dynasim_dir)
    addpath(genpath(dynasim_dir));
end
addpath(fullfile(repo_dir, 'model'));
addpath(fullfile(repo_dir, 'model', 'mechanisms'));

if ispc
    home_dir = getenv('USERPROFILE');
else
    home_dir = getenv('HOME');
end
output_root = fullfile(home_dir, 'soplata-thalcort-2023-output');

if nargin < 1 || isempty(subfolder)
    output_dir = output_root;
else
    output_dir = fullfile(output_root, subfolder);
end

if ~exist(output_dir, 'dir')
    mkdir(output_dir);
end

end

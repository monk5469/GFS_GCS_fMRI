clear all;
close all;

% load parameter file
sP = simtb_create_sP('experiment_params_aod_NoMotion');
% check parameters for permissible values
[errorflag, Message] = simtb_checkparams(sP);
% display error messages, if any
disp(Message)

% Run the simulation
simtb_main(sP);
% save a MASK to make subsequent analyses easier
% MASK = simtb_createmask(sP, 1);
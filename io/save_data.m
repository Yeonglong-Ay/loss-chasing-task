function save_data(fileName, trialData, cfg)
%SAVE_DATA  Save trial data and config to .mat file.
%
%   save_data(fileName, trialData, cfg)
%
%   Called after every trial (incremental save) and at session end.
%   Overwrites the same file each time to avoid accumulating partial files.

save(fileName, 'trialData', 'cfg');
end

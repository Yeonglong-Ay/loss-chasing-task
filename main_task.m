%% main_task.m
% Loss-Chasing Gambling Task — Entry Point
% Yeonglong Ay | Dartmouth College | Sun Lab
%
% Usage: Run this script from the repository root in MATLAB.
%        All parameters are set in config/task_config.m

clearvars; close all; clc;
rng('shuffle');

% ── Add subfolders to path ───────────────────────────────────────────────
addpath('config', 'task', 'stimuli', 'io', 'display', 'utils');

% ── Load configuration ───────────────────────────────────────────────────
cfg = task_config();

% ── Subject info ─────────────────────────────────────────────────────────
[cfg.subjectID, cfg.sessionNum] = get_subject_info();

% ── File setup ───────────────────────────────────────────────────────────
if ~exist('data', 'dir'); mkdir('data'); end
cfg.fileName = fullfile('data', sprintf('%s_ses%02d_%s.mat', ...
    cfg.subjectID, cfg.sessionNum, datestr(now, 'yyyymmdd_HHMMSS')));

% ── Screen setup ─────────────────────────────────────────────────────────
scr = init_screen();

% ── Build block sequence ─────────────────────────────────────────────────
blockSeq = repmat([cfg.NEUTRAL, cfg.LOSS_HEAVY, cfg.WIN_HEAVY], ...
                   1, cfg.nBlocksPerType);
blockSeq = blockSeq(randperm(length(blockSeq)));
nBlocks  = length(blockSeq);

% ── Preallocate data struct ───────────────────────────────────────────────
totalTrials = nBlocks * cfg.nTrialsPerBlock;
trialData   = init_trial_data(totalTrials, cfg.subjectID, ...
                              cfg.sessionNum, blockSeq);

% ── Instructions ─────────────────────────────────────────────────────────
show_instructions(scr, cfg);

% ── Practice ─────────────────────────────────────────────────────────────
run_practice(scr, cfg);

% ── Main task ────────────────────────────────────────────────────────────
trialIdx = 0;

try
    for b = 1:nBlocks
        blockType = blockSeq(b);
        show_block_start(scr, cfg, b, nBlocks, blockType);

        [trialData, trialIdx] = run_block(scr, cfg, trialData, ...
                                          trialIdx, b, blockType);

        if b < nBlocks
            show_rest_screen(scr, cfg, b, nBlocks);
        end
    end

    % ── End of session ────────────────────────────────────────────────────
    totalReward = sum(trialData.rewardEarned, 'omitnan');
    save_data(cfg.fileName, trialData, cfg);
    show_end_screen(scr, cfg, totalReward);

    Priority(0);
    sca;
    fprintf('\nSession complete. Data saved to: %s\n', cfg.fileName);
    fprintf('Total reward earned: $%d\n', totalReward);

catch ME
    save_data(cfg.fileName, trialData, cfg);
    Priority(0);
    sca;
    rethrow(ME);
end

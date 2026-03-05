%% main_task.m
% Loss-Chasing Gambling Task — Entry Point
% Yeonglong Ay | Dartmouth College | Sun Lab

clearvars; close all; clc;
rng('shuffle');

% ── Find repo root based on where THIS file lives ─────────────────────────
thisFile = mfilename('fullpath');
repoRoot = fileparts(thisFile);

fprintf('Repository root: %s\n', repoRoot);

% ── Add subfolders to path ────────────────────────────────────────────────
subfolders = {'config', 'task', 'stimuli', 'io', 'display', 'utils'};

for i = 1:length(subfolders)
    folderPath = fullfile(repoRoot, subfolders{i});
    if exist(folderPath, 'dir')
        addpath(folderPath);
        fprintf('Added to path: %s\n', folderPath);
    else
        error(['Folder not found: %s\n' ...
            'Make sure all subfolders exist under the repo root.'], folderPath);
    end
end

% ── Load configuration ────────────────────────────────────────────────────
cfg = task_config();

% ── Subject info ──────────────────────────────────────────────────────────
[cfg.subjectID, cfg.sessionNum] = get_subject_info();

% ── File setup ────────────────────────────────────────────────────────────
if ~exist('data', 'dir'); mkdir('data'); end
cfg.fileName = fullfile('data', sprintf('%s_ses%02d_%s.mat', ...
    cfg.subjectID, cfg.sessionNum, datestr(now, 'yyyymmdd_HHMMSS')));

% ── Screen setup ──────────────────────────────────────────────────────────
scr = init_screen();

% ── Build block sequence ──────────────────────────────────────────────────
blockSeq = repmat([cfg.NEUTRAL, cfg.LOSS_HEAVY, cfg.WIN_HEAVY], ...
    1, cfg.nBlocksPerType);
blockSeq = blockSeq(randperm(length(blockSeq)));
nBlocks  = length(blockSeq);

% ── Preallocate data struct ───────────────────────────────────────────────
totalTrials = nBlocks * cfg.nTrialsPerBlock;
trialData   = init_trial_data(totalTrials, cfg.subjectID, ...
    cfg.sessionNum, blockSeq);

try
    % ── Instructions ──────────────────────────────────────────────────────
    show_instructions(scr, cfg);

    % ── Practice ──────────────────────────────────────────────────────────
    practiceOK = run_practice(scr, cfg);
    if ~practiceOK
        fprintf('Practice aborted by experimenter.\n');
        save_data(cfg.fileName, trialData, cfg);
        Priority(0);
        sca;
        return;
    end

    % ── Verify window still open before main task ─────────────────────────
    if ~Screen('WindowKind', scr.win)
        error('PTB window closed unexpectedly after practice block.');
    end

    % ── Main Task ─────────────────────────────────────────────────────────
    trialIdx = 0;

    for b = 1:nBlocks
        blockType = blockSeq(b);
        show_block_start(scr, cfg, b, nBlocks, blockType);

        [trialData, trialIdx] = run_block(scr, cfg, trialData, ...
            trialIdx, b, blockType);

        % Check if last block was aborted mid-way
        if trialIdx < b * cfg.nTrialsPerBlock
            fprintf('Block %d aborted. Saving and exiting.\n', b);
            break;
        end

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
    % ── Emergency cleanup ─────────────────────────────────────────────────
    save_data(cfg.fileName, trialData, cfg);
    Priority(0);
    sca;
    fprintf('\n\nERROR in main_task:\n%s\n', ME.message);
    fprintf('Data saved to: %s\n', cfg.fileName);
    rethrow(ME);
end

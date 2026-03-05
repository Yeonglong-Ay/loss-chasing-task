%% main_task.m
% Loss-Chasing Gambling Task — Entry Point
% Yeonglong Ay | Dartmouth College | Sun Lab
%
% Run this file from ANY working directory — it finds its own subfolders
% automatically using the location of main_task.m itself.

clearvars; close all; clc;
rng('shuffle');

% ── Find repo root based on where THIS file lives ─────────────────────────
% This works regardless of what MATLAB's Current Folder is set to
thisFile = mfilename('fullpath');          % full path to main_task.m
repoRoot = fileparts(thisFile);            % strip filename → repo root dir

fprintf('Repository root: %s\n', repoRoot);

% ── Add subfolders to path ────────────────────────────────────────────────
subfolders = {'config', 'task', 'stimuli', 'io', 'display', 'utils'};

for i = 1:length(subfolders)
    folderPath = fullfile(repoRoot, subfolders{i});

    if exist(folderPath, 'dir')
        addpath(folderPath);
        fprintf('Added to path: %s\n', folderPath);
    else
        % Folder missing — create it and warn
        mkdir(folderPath);
        addpath(folderPath);
        warning('Folder did not exist and was created: %s\nMake sure the .m files are inside it.', folderPath);
    end
end

% ── Data directory ────────────────────────────────────────────────────────
dataDir = fullfile(repoRoot, 'data');
if ~exist(dataDir, 'dir')
    mkdir(dataDir);
    fprintf('Created data directory: %s\n', dataDir);
end

% ── Verify critical functions are findable before opening screen ──────────
requiredFunctions = { ...
    'task_config', 'get_subject_info', 'init_screen', ...
    'init_trial_data', 'show_instructions', 'run_practice', ...
    'run_block', 'show_block_start', 'show_rest_screen', ...
    'show_end_screen', 'save_data'};

missingFunctions = {};
for i = 1:length(requiredFunctions)
    if isempty(which(requiredFunctions{i}))
        missingFunctions{end+1} = requiredFunctions{i}; %#ok<AGROW>
    end
end

if ~isempty(missingFunctions)
    fprintf('\n========== MISSING FUNCTIONS ==========\n');
    fprintf('The following required .m files could not be found:\n');
    for i = 1:length(missingFunctions)
        fprintf('  - %s.m\n', missingFunctions{i});
    end
    fprintf('\nExpected folder structure under: %s\n', repoRoot);
    fprintf('  config/    -> task_config.m\n');
    fprintf('  task/      -> run_practice.m, run_block.m, run_trial.m\n');
    fprintf('  stimuli/   -> draw_fixation.m, draw_game_screen.m, draw_outcome.m\n');
    fprintf('  io/        -> get_subject_info.m, get_response.m, save_data.m\n');
    fprintf('  display/   -> show_instructions.m, show_block_start.m,\n');
    fprintf('               show_rest_screen.m, show_end_screen.m\n');
    fprintf('  utils/     -> init_screen.m, init_trial_data.m,\n');
    fprintf('               compute_streak.m, enforce_outcome.m, wait_for_key.m\n');
    fprintf('========================================\n\n');
    error('Cannot start task: %d required function(s) missing. See list above.', ...
          length(missingFunctions));
end

fprintf('All required functions found. Starting task...\n\n');

% ── Load configuration ────────────────────────────────────────────────────
cfg = task_config();

% ── Subject info ──────────────────────────────────────────────────────────
[cfg.subjectID, cfg.sessionNum] = get_subject_info();

% ── File setup ────────────────────────────────────────────────────────────
cfg.fileName = fullfile(dataDir, sprintf('%s_ses%02d_%s.mat', ...
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

        % Detect mid-block abort
        expectedTrials = b * cfg.nTrialsPerBlock;
        if trialIdx < expectedTrials
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
    save_data(cfg.fileName, trialData, cfg);
    Priority(0);
    sca;
    fprintf('\n\nERROR in main_task:\n');
    fprintf('  Message : %s\n', ME.message);
    fprintf('  Function: %s\n', ME.stack(1).name);
    fprintf('  Line    : %d\n', ME.stack(1).line);
    fprintf('Data saved to: %s\n', cfg.fileName);
    rethrow(ME);
end

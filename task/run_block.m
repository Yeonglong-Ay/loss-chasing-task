function [trialData, trialIdx] = run_block(scr, cfg, trialData, ...
                                            trialIdx, b, blockType)
%RUN_BLOCK  Execute all trials within a single block.
%
%   [trialData, trialIdx] = run_block(scr, cfg, trialData,
%                                     trialIdx, b, blockType)

% ── Initialize per-block streak tracking ─────────────────────────────────
streakProgress = 0;
streakTarget   = randi([cfg.streakMin, cfg.streakMax]);
currentStreak  = 0;
lastOutcome    = NaN;

for t = 1:cfg.nTrialsPerBlock
    [trialData, trialIdx, aborted, streakProgress, streakTarget, ...
     currentStreak, lastOutcome] = ...
        run_trial(scr, cfg, trialData, trialIdx, b, blockType, ...
                  streakProgress, streakTarget, currentStreak, lastOutcome);

    % Incremental save after every trial
    save_data(cfg.fileName, trialData, cfg);

    if aborted
        fprintf('Task aborted by experimenter at trial %d.\n', trialIdx);
        save_data(cfg.fileName, trialData, cfg);
        Priority(0);
        sca;
        return;
    end
end
end

function [trialData, trialIdx] = run_block(scr, cfg, trialData, ...
                                            trialIdx, b, blockType)
%RUN_BLOCK  Execute all trials within a single block.
%
%   [trialData, trialIdx] = run_block(scr, cfg, trialData,
%                                     trialIdx, b, blockType)
%
%   Fixed:
%     - Abort no longer calls sca — returns to main_task which handles cleanup
%     - Incremental save still happens after every trial

% ── Per-block streak tracking init ───────────────────────────────────────
streakProgress = 0;
streakTarget   = randi([cfg.streakMin, cfg.streakMax]);
currentStreak  = 0;
lastOutcome    = NaN;

for t = 1:cfg.nTrialsPerBlock

    [trialData, trialIdx, aborted, streakProgress, streakTarget, ...
     currentStreak, lastOutcome] = ...
        run_trial(scr, cfg, trialData, trialIdx, b, blockType, ...
                  streakProgress, streakTarget, currentStreak, lastOutcome);

    % Incremental save after every trial (protects against crashes)
    save_data(cfg.fileName, trialData, cfg);

    if aborted
        fprintf('Task aborted by experimenter at trial %d.\n', trialIdx);
        return;   % Return to main_task for graceful shutdown
    end

end
end

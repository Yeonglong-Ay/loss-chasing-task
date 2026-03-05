function [trialData, trialIdx, aborted, streakProgress, streakTarget, ...
          currentStreak, lastOutcome] = ...
          run_trial(scr, cfg, trialData, trialIdx, b, blockType, ...
                    streakProgress, streakTarget, currentStreak, lastOutcome)
%RUN_TRIAL  Execute a single trial and log all data.
%
%   Fixed:
%     - draw_game_screen now returns flipTime directly (it calls Flip internally)
%     - draw_outcome now calls Flip + WaitSecs internally; no double flip
%     - draw_fixation calls Flip + WaitSecs internally
%     - Removed redundant Screen('Flip') calls after draw_* functions

trialIdx = trialIdx + 1;

% ── Generate trial parameters ─────────────────────────────────────────────
firstNum  = randi([0, 9]);
winProb   = (10 - firstNum) / 10;
gambleAmt = cfg.gambleMin + randi([0, cfg.gambleMax - cfg.gambleMin]);
safeLeft  = randi([0, 1]);

% ── 1. Fixation ───────────────────────────────────────────────────────────
flipTime_fix = draw_fixation(scr, cfg);
% WaitSecs is handled inside draw_fixation

% ── 2. Game Presentation (no response collected) ──────────────────────────
flipTime_game = draw_game_screen(scr, cfg, safeLeft, cfg.safeReward, ...
                                 gambleAmt, firstNum, winProb, 0);
% draw_game_screen calls Flip internally; wait here
WaitSecs(cfg.timing.gamePresent - scr.ifi/2);

% ── 3. Decision Window ────────────────────────────────────────────────────
flipTime_decision = draw_game_screen(scr, cfg, safeLeft, cfg.safeReward, ...
                                     gambleAmt, firstNum, winProb, 1);
% Collect response (draw_game_screen already flipped, so start timing now)
[choice, RT, aborted] = get_response(scr, cfg, flipTime_decision, safeLeft);

if aborted
    % DO NOT call sca here — main_task handles screen closure
    return;
end

% ── 4. Determine Outcome ─────────────────────────────────────────────────
missedResponse = (choice == -1);
gambleChosen   = (choice == 1);
gambleWon      = false;
secondNum      = NaN;
reward         = 0;
isStreakEnforced = false;

if ~missedResponse && gambleChosen
    [secondNum, gambleWon, isStreakEnforced] = enforce_outcome( ...
        firstNum, blockType, winProb, streakProgress, streakTarget, cfg);

    % Update streak progress counter
    if isStreakEnforced
        streakProgress = streakProgress + 1;
    end
    if streakProgress >= streakTarget
        % Streak complete — reset for next streak
        streakProgress = 0;
        streakTarget   = randi([cfg.streakMin, cfg.streakMax]);
    end

    reward = double(gambleWon) * gambleAmt;

elseif ~missedResponse && ~gambleChosen
    % Safe chosen
    reward = cfg.safeReward;
end

% ── 5. Outcome Display ────────────────────────────────────────────────────
% draw_outcome handles Flip + WaitSecs internally
flipTime_outcome = draw_outcome(scr, cfg, choice, gambleChosen, ...
                                gambleWon, gambleAmt, firstNum, secondNum);

% ── 6. Update streak tracking ─────────────────────────────────────────────
[currentStreak, lastOutcome] = compute_streak(gambleChosen, gambleWon, ...
                                              missedResponse, ...
                                              currentStreak, lastOutcome);
lostChase = double(gambleChosen && currentStreak >= 2);

% ── 7. ITI ────────────────────────────────────────────────────────────────
Screen('FillRect', scr.win, scr.black);
Screen('Flip', scr.win);
WaitSecs(cfg.timing.iti - scr.ifi/2);

% ── 8. Log Data ───────────────────────────────────────────────────────────
trialData.trialNum(trialIdx)             = trialIdx;
trialData.blockNum(trialIdx)             = b;
trialData.blockType(trialIdx)            = blockType;
trialData.winProbCue(trialIdx)           = winProb;
trialData.gambleAmount(trialIdx)         = gambleAmt;
trialData.safeLeft(trialIdx)             = safeLeft;
trialData.choice(trialIdx)               = choice;
trialData.RT(trialIdx)                   = RT;
trialData.outcomeFirstNum(trialIdx)      = firstNum;
trialData.outcomeSecondNum(trialIdx)     = secondNum;
trialData.gambleWon(trialIdx)            = double(gambleWon);
trialData.rewardEarned(trialIdx)         = reward;
trialData.streakLength(trialIdx)         = currentStreak;
trialData.isStreakEnforced(trialIdx)     = double(isStreakEnforced);
trialData.lostChase(trialIdx)            = lostChase;
trialData.missedResponse(trialIdx)       = double(missedResponse);
trialData.flipTime_fixation(trialIdx)    = flipTime_fix;
trialData.flipTime_gamePresent(trialIdx) = flipTime_game;
trialData.flipTime_decision(trialIdx)    = flipTime_decision;
trialData.flipTime_outcome(trialIdx)     = flipTime_outcome;
end

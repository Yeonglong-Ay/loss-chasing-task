function [trialData, trialIdx, aborted, streakProgress, streakTarget, ...
          currentStreak, lastOutcome] = ...
          run_trial(scr, cfg, trialData, trialIdx, b, blockType, ...
                    streakProgress, streakTarget, currentStreak, lastOutcome)
%RUN_TRIAL  Execute a single trial and log all data.
%
%   Handles: fixation → game presentation → decision → outcome → ITI
%   Returns updated trial data struct and streak tracking variables.

trialIdx = trialIdx + 1;

% ── Generate trial parameters ─────────────────────────────────────────────
firstNum  = randi([0, 9]);
winProb   = (10 - firstNum) / 10;
gambleAmt = cfg.gambleMin + randi([0, cfg.gambleMax - cfg.gambleMin]);
safeLeft  = randi([0, 1]);

% ── Fixation ──────────────────────────────────────────────────────────────
flipTime_fix = draw_fixation(scr, cfg);

% ── Game presentation (no response) ──────────────────────────────────────
draw_game_screen(scr, cfg, safeLeft, cfg.safeReward, ...
                 gambleAmt, firstNum, winProb, 0);
flipTime_game = Screen('Flip', scr.win);
WaitSecs(cfg.timing.gamePresent - scr.ifi / 2);

% ── Decision window ───────────────────────────────────────────────────────
draw_game_screen(scr, cfg, safeLeft, cfg.safeReward, ...
                 gambleAmt, firstNum, winProb, 1);
flipTime_decision = Screen('Flip', scr.win);

[choice, RT, aborted] = get_response(scr, cfg, flipTime_decision, safeLeft);

if aborted; return; end

% ── Determine outcome ─────────────────────────────────────────────────────
missedResponse = (choice == -1);
gambleChosen   = (choice == 1);
gambleWon      = false;
secondNum      = NaN;
reward         = 0;

if ~missedResponse && gambleChosen
    [secondNum, gambleWon, isStreakEnforced] = enforce_outcome( ...
        firstNum, blockType, winProb, streakProgress, streakTarget, cfg);

    % Update streak progress counter
    inStreak = (streakProgress < streakTarget);
    if isStreakEnforced && inStreak
        streakProgress = streakProgress + 1;
    elseif streakProgress >= streakTarget
        % Streak complete — reset for next streak
        streakProgress = 0;
        streakTarget   = randi([cfg.streakMin, cfg.streakMax]);
    end

    reward = gambleWon * gambleAmt;
else
    isStreakEnforced = false;
    if ~missedResponse
        reward = cfg.safeReward;    % safe chosen
    end
end

% ── Outcome display ───────────────────────────────────────────────────────
flipTime_outcome = draw_outcome(scr, cfg, choice, gambleChosen, ...
                                gambleWon, gambleAmt, firstNum, secondNum);

% ── Update streak tracking ────────────────────────────────────────────────
[currentStreak, lastOutcome] = compute_streak(gambleChosen, gambleWon, ...
                                              missedResponse, ...
                                              currentStreak, lastOutcome);
lostChase = (gambleChosen && currentStreak >= 2);

% ── ITI ───────────────────────────────────────────────────────────────────
Screen('FillRect', scr.win, scr.black);
Screen('Flip', scr.win);
WaitSecs(cfg.timing.iti - scr.ifi / 2);

% ── Log data ──────────────────────────────────────────────────────────────
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
trialData.lostChase(trialIdx)            = double(lostChase);
trialData.missedResponse(trialIdx)       = double(missedResponse);
trialData.flipTime_fixation(trialIdx)    = flipTime_fix;
trialData.flipTime_gamePresent(trialIdx) = flipTime_game;
trialData.flipTime_decision(trialIdx)    = flipTime_decision;
trialData.flipTime_outcome(trialIdx)     = flipTime_outcome;
end

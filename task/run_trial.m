function [trialData, trialIdx, aborted, streakProgress, streakTarget, ...
          currentStreak, lastOutcome] = ...
          run_trial(scr, cfg, trialData, trialIdx, b, blockType, ...
                    streakProgress, streakTarget, currentStreak, lastOutcome)
%RUN_TRIAL  Execute a single trial and log all data.
%
%  TIMING CONTRACT (each draw_* function owns its OWN Flip):
%    draw_fixation     → flips + waits  fixation duration internally
%    draw_game_screen  → flips ONLY     (no wait); caller waits here
%    draw_outcome      → flips + waits  outcome duration internally
%  Callers must NOT call Screen('Flip') after any draw_* function.

trialIdx = trialIdx + 1;

% ── Generate trial parameters ─────────────────────────────────────────────
firstNum  = randi([0, 9]);
winProb   = (10 - firstNum) / 10;
gambleAmt = cfg.gambleMin + randi([0, cfg.gambleMax - cfg.gambleMin]);
safeLeft  = randi([0, 1]);

% ── 1. Fixation (flip + wait inside draw_fixation) ───────────────────────
flipTime_fix = draw_fixation(scr, cfg);

% ── 2. Game Presentation — showPrompt = 0 ────────────────────────────────
% draw_game_screen flips internally and returns the flip timestamp.
% We then wait the gamePresent duration HERE in the caller.
flipTime_game = draw_game_screen(scr, cfg, safeLeft, cfg.safeReward, ...
                                 gambleAmt, firstNum, winProb, 0);
WaitSecs(cfg.timing.gamePresent - scr.ifi/2);

% ── 3. Decision Window — showPrompt = 1 ──────────────────────────────────
% Flip the decision screen; get_response starts timing from this flip.
flipTime_decision = draw_game_screen(scr, cfg, safeLeft, cfg.safeReward, ...
                                     gambleAmt, firstNum, winProb, 1);
% Response collection — runs until key press or maxDecision timeout
[choice, RT, aborted] = get_response(scr, cfg, flipTime_decision, safeLeft);

if aborted
    return;   % main_task handles sca
end

% ── 4. Determine Outcome ─────────────────────────────────────────────────
missedResponse   = (choice == -1);
gambleChosen     = (choice == 1);
gambleWon        = false;
secondNum        = NaN;
reward           = 0;
isStreakEnforced = false;

if ~missedResponse && gambleChosen
    % Adaptive streak sequencing
    [secondNum, gambleWon, isStreakEnforced] = enforce_outcome( ...
        firstNum, blockType, winProb, streakProgress, streakTarget, cfg);

    % Update streak progress
    if isStreakEnforced
        streakProgress = streakProgress + 1;
    end
    if streakProgress >= streakTarget
        streakProgress = 0;
        streakTarget   = randi([cfg.streakMin, cfg.streakMax]);
    end

    reward = double(gambleWon) * gambleAmt;

elseif ~missedResponse && ~gambleChosen
    reward = cfg.safeReward;
end

% ── 5. Outcome Display (flip + wait inside draw_outcome) ─────────────────
flipTime_outcome = draw_outcome(scr, cfg, choice, gambleChosen, ...
                                gambleWon, gambleAmt, firstNum, secondNum);

% ── 6. Update streak tracking ─────────────────────────────────────────────
[currentStreak, lastOutcome] = compute_streak(gambleChosen, gambleWon, ...
                                              missedResponse, ...
                                              currentStreak, lastOutcome);
lostChase = double(gambleChosen && currentStreak >= 2);

% ── 7. ITI — blank screen ────────────────────────────────────────────────
Screen('FillRect', scr.win, scr.black);
Screen('Flip', scr.win);
WaitSecs(cfg.timing.iti - scr.ifi/2);

% ── 8. Log trial data ─────────────────────────────────────────────────────
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

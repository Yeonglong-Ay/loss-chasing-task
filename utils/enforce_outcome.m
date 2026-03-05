function [secondNum, gambleWon, isEnforced] = enforce_outcome(firstNum, ...
                                               blockType, winProb, ...
                                               streakProgress, streakTarget, ...
                                               cfg)
%ENFORCE_OUTCOME  Determine second integer and win/loss based on block type.
%
%   Implements the adaptive streak sequencing algorithm:
%     - Loss-heavy blocks: force loss (secondNum <= firstNum) for
%       streakTarget consecutive gamble trials
%     - Win-heavy blocks:  force win  (secondNum >  firstNum) for
%       streakTarget consecutive gamble trials
%     - Neutral blocks or after streak is complete: free outcome
%
%   [secondNum, gambleWon, isEnforced] = enforce_outcome(firstNum,
%       blockType, winProb, streakProgress, streakTarget, cfg)

NEUTRAL    = cfg.NEUTRAL;
LOSS_HEAVY = cfg.LOSS_HEAVY;
WIN_HEAVY  = cfg.WIN_HEAVY;
threshold  = cfg.streakWinProbThreshold;

isEnforced = false;
inStreak   = (streakProgress < streakTarget);

if blockType == LOSS_HEAVY && winProb >= threshold && inStreak
    % ── Force LOSS: secondNum <= firstNum ────────────────────────────────
    isEnforced = true;
    if firstNum == 0
        secondNum = 0;  % tie = loss (win requires strictly greater)
    else
        secondNum = randi([0, firstNum]);
    end
    gambleWon = false;

elseif blockType == WIN_HEAVY && winProb >= threshold && inStreak
    % ── Force WIN: secondNum > firstNum ──────────────────────────────────
    isEnforced = true;
    if firstNum >= 9
        % Edge case: can't win if firstNum == 9; fallback to free draw
        secondNum  = draw_free_second(firstNum);
        gambleWon  = (secondNum > firstNum);
        isEnforced = false;
    else
        secondNum = randi([firstNum + 1, 9]);
        gambleWon = true;
    end

else
    % ── Free outcome ─────────────────────────────────────────────────────
    secondNum = draw_free_second(firstNum);
    gambleWon = (secondNum > firstNum);
end
end

% ── Helper: draw a second number with no ties ─────────────────────────────
function secondNum = draw_free_second(firstNum)
    secondNum = randi([0, 9]);
    while secondNum == firstNum
        secondNum = randi([0, 9]);
    end
end

function flipTime = draw_outcome(scr, cfg, choice, gambleChosen, ...
                                  gambleWon, gambleAmt, firstNum, secondNum)
%DRAW_OUTCOME  Draw outcome feedback screen and wait outcome duration.
%
%   flipTime = draw_outcome(scr, cfg, choice, gambleChosen,
%                           gambleWon, gambleAmt, firstNum, secondNum)

Screen('FillRect', scr.win, scr.black);

if choice == -1
    % ── Missed response ───────────────────────────────────────────────────
    outcomeText  = 'TOO SLOW!';
    outcomeColor = scr.red;

elseif ~gambleChosen
    % ── Safe chosen ───────────────────────────────────────────────────────
    outcomeText  = sprintf('Safe Choice: +$%d', cfg.safeReward);
    outcomeColor = scr.white;

else
    % ── Gamble outcome ────────────────────────────────────────────────────
    if gambleWon
        outcomeText  = sprintf('Gamble WON: +$%d!', gambleAmt);
        outcomeColor = scr.green;
    else
        outcomeText  = 'Gamble LOST: $0';
        outcomeColor = scr.red;
    end
    % Show the number reveal
    numText = sprintf('Your number: %d  |  Table number: %d', ...
                      firstNum, secondNum);
    DrawFormattedText(scr.win, numText, 'center', scr.cy + 70, scr.grey);
end

DrawFormattedText(scr.win, outcomeText, 'center', scr.cy, outcomeColor);
flipTime = Screen('Flip', scr.win);
WaitSecs(cfg.timing.outcome - scr.ifi / 2);
end

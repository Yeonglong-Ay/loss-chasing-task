function flipTime = draw_outcome(scr, cfg, choice, gambleChosen, ...
    gambleWon, gambleAmt, firstNum, secondNum)
%DRAW_OUTCOME  Draw outcome feedback screen and wait outcome duration.
%
%   flipTime = draw_outcome(scr, cfg, choice, gambleChosen,
%                           gambleWon, gambleAmt, firstNum, secondNum)
%
%   Fixed:
%     - Flip now happens inside this function (consistent with draw_game_screen)
%     - WaitSecs moved here so caller doesn't need to manage it

Screen('FillRect', scr.win, scr.black);

if choice == -1
    % ── Missed response ───────────────────────────────────────────────────
    outcomeText  = 'TOO SLOW!';
    outcomeColor = scr.red;
    DrawFormattedText(scr.win, outcomeText, 'center', 'center', outcomeColor);

elseif ~gambleChosen
    % ── Safe chosen ───────────────────────────────────────────────────────
    outcomeText  = sprintf('Safe Choice:  +$%d', cfg.safeReward);
    outcomeColor = scr.white;
    DrawFormattedText(scr.win, outcomeText, 'center', 'center', outcomeColor);

else
    % ── Gamble outcome ────────────────────────────────────────────────────
    if gambleWon
        outcomeText  = sprintf('Gamble WON:  +$%d !', gambleAmt);
        outcomeColor = scr.green;
    else
        outcomeText  = 'Gamble LOST:  $0';
        outcomeColor = scr.red;
    end
    DrawFormattedText(scr.win, outcomeText, 'center', scr.cy - 40, outcomeColor);

    % Show number reveal below outcome text
    numText = sprintf('Your number:  %d     |     Table number:  %d', ...
        firstNum, secondNum);
    DrawFormattedText(scr.win, numText, 'center', scr.cy + 40, scr.grey);
end

flipTime = Screen('Flip', scr.win);
WaitSecs(cfg.timing.outcome - scr.ifi/2);
end

function draw_outcome(scr, cfg, choice, gambleChosen, gambleWon, ...
    gambleAmt, firstNum, secondNum)
%DRAW_OUTCOME  Draw outcome screen (win/loss/safe) and flip.
%
%   draw_outcome(scr, cfg, choice, gambleChosen, gambleWon, gambleAmt, ...
%                firstNum, secondNum)

Screen('FillRect', scr.win, scr.black);

cx = scr.cx;
cy = scr.cy;

if choice == -1
    % Timeout
    outcomeText = 'TOO SLOW!';
    outcomeColor = scr.red;
elseif choice == 0
    % Safe chosen
    outcomeText = sprintf('Safe: +$%d', cfg.safeReward);
    outcomeColor = scr.white;
else
    % Gamble chosen
    if gambleWon
        outcomeText = sprintf('Gamble WON: +$%d!', gambleAmt);
        outcomeColor = scr.green;
    else
        outcomeText = 'Gamble LOST: $0';
        outcomeColor = scr.red;
    end
end

DrawFormattedText(scr.win, outcomeText, 'center', cy, outcomeColor);
Screen('Flip', scr.win);
WaitSecs(cfg.timing.outcome - scr.ifi/2);
end

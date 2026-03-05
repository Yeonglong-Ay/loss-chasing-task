function flipTime = draw_game_screen(scr, cfg, safeLeft, safeReward, ...
    gambleAmt, firstNum, winProb, showPrompt)
%DRAW_GAME_SCREEN  Draw game screen and flip. Caller handles WaitSecs.
%
%  This function only DRAWS and FLIPS — it does NOT call WaitSecs.
%  The caller (run_trial) is responsible for waiting after each flip
%  so that timing is transparent and controllable from one place.

Screen('FillRect', scr.win, scr.black);

cx = scr.cx;
cy = scr.cy;
winProbPct = round(winProb * 100);

% ── Win probability header ────────────────────────────────────────────────
probText = sprintf('Win Probability Cue:  %d   (%d%%)', firstNum, winProbPct);
DrawFormattedText(scr.win, probText, 'center', cy - 180, scr.grey);

% ── Box geometry ─────────────────────────────────────────────────────────
boxW     = 240;
boxH     = 170;
boxY_top = cy - boxH/2 - 20;
lineW    = 3;

leftBoxCx  = cx - 280;
rightBoxCx = cx + 280;

leftRect  = [leftBoxCx  - boxW/2, boxY_top, leftBoxCx  + boxW/2, boxY_top + boxH];
rightRect = [rightBoxCx - boxW/2, boxY_top, rightBoxCx + boxW/2, boxY_top + boxH];

% ── Assign labels ─────────────────────────────────────────────────────────
if safeLeft
    leftLabel  = sprintf('SAFE\n\n+$%d', safeReward);
    rightLabel = sprintf('GAMBLE\n\n+$%d\n(%d%%)', gambleAmt, winProbPct);
    leftColor  = scr.white;
    rightColor = scr.yellow;
else
    leftLabel  = sprintf('GAMBLE\n\n+$%d\n(%d%%)', gambleAmt, winProbPct);
    rightLabel = sprintf('SAFE\n\n+$%d', safeReward);
    leftColor  = scr.yellow;
    rightColor = scr.white;
end

% ── Draw boxes ────────────────────────────────────────────────────────────
Screen('FrameRect', scr.win, leftColor,  leftRect,  lineW);
Screen('FrameRect', scr.win, rightColor, rightRect, lineW);

DrawFormattedText(scr.win, leftLabel,  leftBoxCx  - boxW/2 + 10, boxY_top + 25, leftColor);
DrawFormattedText(scr.win, rightLabel, rightBoxCx - boxW/2 + 10, boxY_top + 25, rightColor);

% ── Response prompt (decision window only) ────────────────────────────────
if showPrompt
    DrawFormattedText(scr.win, '<-- LEFT            RIGHT -->', ...
        'center', cy + 145, scr.grey);
    DrawFormattedText(scr.win, 'Choose Now!  (Left or Right Arrow)', ...
        'center', cy + 190, scr.white);
end

% ── Single flip — NO WaitSecs here ───────────────────────────────────────
flipTime = Screen('Flip', scr.win);
end

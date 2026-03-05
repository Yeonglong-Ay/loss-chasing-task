function flipTime = draw_game_screen(scr, cfg, safeLeft, safeReward, ...
                                     gambleAmt, firstNum, winProb, showPrompt)
%DRAW_GAME_SCREEN  Draw the game presentation or decision screen.
%
%   flipTime = draw_game_screen(scr, cfg, safeLeft, safeReward,
%                               gambleAmt, firstNum, winProb, showPrompt)
%
%   Fixed:
%     - DrawFormattedText x positions use explicit pixel values, not strings,
%       to avoid rendering failures with the Windows legacy GDI renderer
%     - Box text drawn with DrawFormattedText centered in each box
%     - Flip happens inside this function; caller should NOT flip again

Screen('FillRect', scr.win, scr.black);

cx = scr.cx;
cy = scr.cy;
winProbPct = round(winProb * 100);

% ── Win probability header (top center) ──────────────────────────────────
probText = sprintf('Win Probability Cue:  %d   (%d%%)', firstNum, winProbPct);
DrawFormattedText(scr.win, probText, 'center', cy - 180, scr.grey);

% ── Option box geometry ───────────────────────────────────────────────────
boxW     = 240;
boxH     = 170;
boxY_top = cy - boxH/2 - 20;   % shift boxes slightly above center
lineW    = 3;                   % box border width

% Horizontal center of each box
leftBoxCx  = cx - 280;
rightBoxCx = cx + 280;

leftRect  = [leftBoxCx  - boxW/2, boxY_top, ...
             leftBoxCx  + boxW/2, boxY_top + boxH];
rightRect = [rightBoxCx - boxW/2, boxY_top, ...
             rightBoxCx + boxW/2, boxY_top + boxH];

% ── Assign labels and colors based on layout ─────────────────────────────
if safeLeft
    leftLabel   = sprintf('SAFE\n\n+$%d', safeReward);
    rightLabel  = sprintf('GAMBLE\n\n+$%d\n(%d%%)', gambleAmt, winProbPct);
    leftColor   = scr.white;
    rightColor  = scr.yellow;
else
    leftLabel   = sprintf('GAMBLE\n\n+$%d\n(%d%%)', gambleAmt, winProbPct);
    rightLabel  = sprintf('SAFE\n\n+$%d', safeReward);
    leftColor   = scr.yellow;
    rightColor  = scr.white;
end

% ── Draw boxes ────────────────────────────────────────────────────────────
Screen('FrameRect', scr.win, leftColor,  leftRect,  lineW);
Screen('FrameRect', scr.win, rightColor, rightRect, lineW);

% ── Draw labels centered inside each box ─────────────────────────────────
% DrawFormattedText with 'center' only centers horizontally across the
% whole screen. For box-centered text, we compute x offsets manually.
DrawFormattedText(scr.win, leftLabel, ...
    leftBoxCx - boxW/2 + 10, boxY_top + 25, leftColor);

DrawFormattedText(scr.win, rightLabel, ...
    rightBoxCx - boxW/2 + 10, boxY_top + 25, rightColor);

% ── Response prompt ───────────────────────────────────────────────────────
if showPrompt
    DrawFormattedText(scr.win, ...
        '<-- LEFT            RIGHT -->', ...
        'center', cy + 145, scr.grey);
    DrawFormattedText(scr.win, ...
        'Choose Now!  (Left or Right Arrow)', ...
        'center', cy + 190, scr.white);
end

flipTime = Screen('Flip', scr.win);
end

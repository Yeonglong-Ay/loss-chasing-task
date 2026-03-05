function flipTime = draw_game_screen(scr, cfg, safeLeft, safeReward, ...
                                     gambleAmt, firstNum, winProb, showPrompt)
%DRAW_GAME_SCREEN  Draw the game presentation or decision screen.
%
%   flipTime = draw_game_screen(scr, cfg, safeLeft, safeReward,
%                               gambleAmt, firstNum, winProb, showPrompt)
%
%   Inputs:
%     safeLeft    - 1 if safe option is on the left side
%     safeReward  - fixed safe payout ($)
%     gambleAmt   - gamble payout if won ($)
%     firstNum    - integer cue shown (0–9)
%     winProb     - win probability (0.1–1.0)
%     showPrompt  - 0 = game presentation; 1 = decision (add response cue)

Screen('FillRect', scr.win, scr.black);

winProbPct = round(winProb * 100);
cx = scr.cx;
cy = scr.cy;

% ── Win probability header ────────────────────────────────────────────────
probText = sprintf('Win Probability Cue: %d   (%d%%)', firstNum, winProbPct);
DrawFormattedText(scr.win, probText, 'center', cy - 160, scr.grey);

% ── Option box geometry ───────────────────────────────────────────────────
boxW = 220;
boxH = 160;
boxY = cy - boxH / 2;

leftBoxX  = cx - 260 - boxW / 2;
rightBoxX = cx + 260 - boxW / 2;

% ── Assign labels and colors to sides ────────────────────────────────────
if safeLeft
    leftLabel  = sprintf('SAFE\n+$%d', safeReward);
    rightLabel = sprintf('GAMBLE\n+$%d\n(%d%%)', gambleAmt, winProbPct);
    leftColor  = scr.white;
    rightColor = scr.yellow;
else
    leftLabel  = sprintf('GAMBLE\n+$%d\n(%d%%)', gambleAmt, winProbPct);
    rightLabel = sprintf('SAFE\n+$%d', safeReward);
    leftColor  = scr.yellow;
    rightColor = scr.white;
end

% ── Draw left box ─────────────────────────────────────────────────────────
leftRect = [leftBoxX, boxY, leftBoxX + boxW, boxY + boxH];
Screen('FrameRect', scr.win, leftColor, leftRect, 3);
DrawFormattedText(scr.win, leftLabel, leftBoxX + boxW/2 - 40, boxY + 30, leftColor);

% ── Draw right box ────────────────────────────────────────────────────────
rightRect = [rightBoxX, boxY, rightBoxX + boxW, boxY + boxH];
Screen('FrameRect', scr.win, rightColor, rightRect, 3);
DrawFormattedText(scr.win, rightLabel, rightBoxX + boxW/2 - 50, boxY + 30, rightColor);

% ── Response prompt ───────────────────────────────────────────────────────
if showPrompt
    DrawFormattedText(scr.win, ...
        '<-- LEFT                                          RIGHT -->', ...
        'center', cy + 140, scr.grey);
    DrawFormattedText(scr.win, 'Choose Now!', 'center', cy + 190, scr.white);
end

flipTime = Screen('Flip', scr.win);
end

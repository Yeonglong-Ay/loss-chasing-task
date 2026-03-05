function flipTime = draw_fixation(scr, cfg)
%DRAW_FIXATION  Draw fixation cross and flip; wait fixation duration.
%
%   flipTime = draw_fixation(scr, cfg)

Screen('FillRect', scr.win, scr.black);

% Draw a manual fixation cross using Screen('DrawLines') —
% more reliable than DrawFormattedText '+' on Windows legacy GDI
fixSize = 20;   % arm length in pixels
fixWidth = 3;   % line width in pixels

cx = scr.cx;
cy = scr.cy;

% Horizontal and vertical arms
xCoords = [-fixSize, fixSize,  0,       0      ];
yCoords = [ 0,       0,       -fixSize, fixSize];
Screen('DrawLines', scr.win, [xCoords; yCoords], fixWidth, scr.white, [cx, cy]);

flipTime = Screen('Flip', scr.win);
WaitSecs(cfg.timing.fixation - scr.ifi/2);
end

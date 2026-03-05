function flipTime = draw_fixation(scr, cfg)
%DRAW_FIXATION  Draw fixation cross and flip; wait fixation duration.
%
%   flipTime = draw_fixation(scr, cfg)

Screen('FillRect', scr.win, scr.black);
DrawFormattedText(scr.win, '+', 'center', scr.cy, scr.white);
flipTime = Screen('Flip', scr.win);
WaitSecs(cfg.timing.fixation - scr.ifi / 2);
end

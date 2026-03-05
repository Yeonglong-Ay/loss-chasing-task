function show_end_screen(scr, cfg, totalReward)
%SHOW_END_SCREEN  Display session complete screen with total earnings.
%
%   show_end_screen(scr, cfg, totalReward)

Screen('FillRect', scr.win, scr.black);
endText = sprintf( ...
    ['Session Complete!\n\n' ...
     'Total Earned:  $%d\n\n' ...
     'Thank you for participating.\n\n' ...
     'Press SPACE to exit.'], totalReward);
DrawFormattedText(scr.win, endText, 'center', 'center', scr.white, 60);
Screen('Flip', scr.win);
wait_for_key(cfg.keys.space);
end

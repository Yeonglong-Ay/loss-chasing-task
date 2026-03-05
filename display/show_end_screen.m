function show_end_screen(scr, cfg, trialData)
%SHOW_END_SCREEN  Display final screen with earnings summary.
%
%   show_end_screen(scr, cfg, trialData)

totalReward = sum(trialData.rewardEarned);
finalText = sprintf( ...
    'Task Complete!\n\n' ...
    'Total Earnings: $%d\n\n' ...
    'Thank you for participating!', ...
    totalReward);

Screen('FillRect', scr.win, scr.black);
DrawFormattedText(scr.win, finalText, 'center', 'center', scr.white);
Screen('Flip', scr.win);
wait_for_key(cfg.keys.space);
end

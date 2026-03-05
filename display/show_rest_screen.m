function show_rest_screen(scr, cfg, blockNum, nBlocks)
%SHOW_REST_SCREEN  Display between-block rest screen; wait for SPACE.
%
%   show_rest_screen(scr, cfg, blockNum, nBlocks)

restText = sprintf( ...
    'Rest Break\n\nCompleted %d of %d blocks.\n\nTake a short break.\n\nPress SPACE when ready to continue.', ...
    blockNum, nBlocks);

Screen('FillRect', scr.win, scr.black);
DrawFormattedText(scr.win, restText, 'center', 'center', scr.white);
Screen('Flip', scr.win);
wait_for_key(cfg.keys.space);
end

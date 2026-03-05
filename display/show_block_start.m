function show_block_start(scr, cfg, blockNum, nBlocks, blockType)
%SHOW_BLOCK_START  Display block number and type; wait for SPACE.
%
%   show_block_start(scr, cfg, blockNum, nBlocks, blockType)

blockText = sprintf('Block %d of %d\n\nBlock Type: %s\n\nPress SPACE when ready.', ...
    blockNum, nBlocks, cfg.blockTypeNames{blockType});

Screen('FillRect', scr.win, scr.black);
DrawFormattedText(scr.win, blockText, 'center', 'center', scr.white);
Screen('Flip', scr.win);
wait_for_key(cfg.keys.space);
end

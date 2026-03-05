function show_block_start(scr, cfg, blockNum, nBlocks, blockType)
%SHOW_BLOCK_START  Display block number prompt; wait for SPACE.
%
%   show_block_start(scr, cfg, blockNum, nBlocks, blockType)
%
%   Fixed:
%     - Added isopen check so we get a clear error if window was closed
%     - Defensive Screen('FillRect') before DrawFormattedText

if ~Screen('WindowKind', scr.win)
    error('show_block_start: PTB window is not open (win=%d). Was sca called early?', ...
          scr.win);
end

Screen('FillRect', scr.win, scr.black);

blockText = sprintf( ...
    'Block  %d  of  %d\n\nBlock Type:  %s\n\nPress SPACE when ready.', ...
    blockNum, nBlocks, cfg.blockTypeNames{blockType});

DrawFormattedText(scr.win, blockText, 'center', 'center', scr.white, 60);
Screen('Flip', scr.win);
wait_for_key(cfg.keys.space);
end

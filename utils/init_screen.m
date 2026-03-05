function scr = init_screen()
%INIT_SCREEN  Open Psychtoolbox window and return screen parameters struct.
%
%   scr = init_screen()
%
%   Fields returned:
%     scr.win      - PTB window pointer
%     scr.winRect  - screen rectangle
%     scr.cx, cy   - screen center coordinates
%     scr.ifi      - inter-flip interval (seconds)
%     scr.white / black / grey / green / red / yellow

PsychDefaultSetup(2);
Screen('Preference', 'SkipSyncTests', 0);
AssertOpenGL;

screenNum = max(Screen('Screens'));

scr.white  = WhiteIndex(screenNum);
scr.black  = BlackIndex(screenNum);
scr.grey   = scr.white / 2;
scr.green  = [0, 200, 0];
scr.red    = [200, 0, 0];
scr.yellow = [255, 215, 0];

[scr.win, scr.winRect] = Screen('OpenWindow', screenNum, scr.black);
Screen('BlendFunction', scr.win, GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
Screen('TextFont',  scr.win, 'Arial');
Screen('TextSize',  scr.win, 36);
Screen('TextStyle', scr.win, 1);  % bold

[scr.cx, scr.cy] = RectCenter(scr.winRect);
scr.ifi = Screen('GetFlipInterval', scr.win);

Priority(MaxPriority(scr.win));
end

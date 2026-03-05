function scr = init_screen()
%INIT_SCREEN  Open Psychtoolbox window and return screen parameters struct.
%
%   scr = init_screen()
%
%   Fixed:
%     - Removed GL_SRC_ALPHA constants (not reliably defined on Windows)
%     - TextFont/Size/Style set AFTER OpenWindow
%     - SkipSyncTests set to 1 for Windows DWM compatibility warning
%       (set back to 0 for actual data collection)

PsychDefaultSetup(2);

% ── Windows DWM workaround ────────────────────────────────────────────────
% The DWM compositor warning is informational only on Windows 10/11.
% SkipSyncTests = 1 suppresses the hard sync error during development;
% change to 0 for actual data collection and verify with external equipment.
Screen('Preference', 'SkipSyncTests', 1);
Screen('Preference', 'Verbosity', 3);

AssertOpenGL;

screenNum = max(Screen('Screens'));

% ── Define colors ─────────────────────────────────────────────────────────
scr.white  = WhiteIndex(screenNum);
scr.black  = BlackIndex(screenNum);
scr.grey   = round(scr.white / 2);
scr.green  = [0, 200, 0];
scr.red    = [200, 0, 0];
scr.yellow = [255, 215, 0];

% ── Open window ───────────────────────────────────────────────────────────
[scr.win, scr.winRect] = Screen('OpenWindow', screenNum, scr.black);

% ── Text settings MUST come after OpenWindow on Windows ──────────────────
Screen('TextFont',  scr.win, 'Arial');
Screen('TextSize',  scr.win, 32);
Screen('TextStyle', scr.win, 1);   % bold

% ── Blend function using numeric constants (Windows-safe) ─────────────────
% GL_SRC_ALPHA = 770, GL_ONE_MINUS_SRC_ALPHA = 771
Screen('BlendFunction', scr.win, 770, 771);

% ── Screen geometry ───────────────────────────────────────────────────────
[scr.cx, scr.cy] = RectCenter(scr.winRect);
scr.ifi = Screen('GetFlipInterval', scr.win);

% ── Priority ─────────────────────────────────────────────────────────────
Priority(MaxPriority(scr.win));

fprintf('Screen opened: %d x %d @ %.1f Hz\n', ...
    scr.winRect(3), scr.winRect(4), 1/scr.ifi);
end

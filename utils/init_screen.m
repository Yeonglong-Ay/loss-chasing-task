function scr = init_screen()
%INIT_SCREEN  Open Psychtoolbox window and return screen parameters struct.
%
%   scr = init_screen()

PsychDefaultSetup(2);

% ── Windows DWM workaround ────────────────────────────────────────────────
% SkipSyncTests = 1 for development on Windows 10/11 with DWM active.
% Set back to 0 for actual data collection and verify timing externally.
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

% ── Blend function using string names — cross-platform safe ───────────────
try
    Screen('BlendFunction', scr.win, 'GL_SRC_ALPHA', 'GL_ONE_MINUS_SRC_ALPHA');
catch blendErr
    warning('init_screen: BlendFunction failed (non-critical): %s', blendErr.message);
end

% ── Screen geometry ───────────────────────────────────────────────────────
[scr.cx, scr.cy] = RectCenter(scr.winRect);
scr.ifi = Screen('GetFlipInterval', scr.win);

% ── Priority ─────────────────────────────────────────────────────────────
Priority(MaxPriority(scr.win));
end

function cfg = task_config()
%TASK_CONFIG  Return struct of all task parameters.
%
%   cfg = task_config()
%
%   Edit this file to change timing, rewards, streak parameters,
%   or key bindings without touching any execution logic.

% ── Block type codes ──────────────────────────────────────────────────────
cfg.NEUTRAL    = 1;
cfg.LOSS_HEAVY = 2;
cfg.WIN_HEAVY  = 3;
cfg.blockTypeNames = {'Neutral', 'Loss-Heavy', 'Win-Heavy'};

% ── Session structure ─────────────────────────────────────────────────────
cfg.nTrialsPerBlock = 21;   % trials per block
cfg.nBlocksPerType  = 2;    % repetitions of each block type per session
% total blocks = 3 types * 2 = 6
% total trials = 6 * 21 = 126

% ── Timing (seconds) ─────────────────────────────────────────────────────
cfg.timing.fixation    = 0.500;
cfg.timing.gamePresent = 0.750;
cfg.timing.maxDecision = 4.000;
cfg.timing.outcome     = 0.550;
cfg.timing.iti         = 1.000;

% ── Reward parameters ────────────────────────────────────────────────────
cfg.safeReward  = 10;   % fixed safe option payout ($)
cfg.gambleMin   = 15;   % minimum gamble reward ($)
cfg.gambleMax   = 30;   % maximum gamble reward ($)

% ── Streak parameters ────────────────────────────────────────────────────
cfg.streakMin = 3;      % minimum enforced streak length
cfg.streakMax = 4;      % maximum enforced streak length

% Enforcement only applied when win prob >= this threshold
% (naturalistic: gambling is more common on high-prob trials)
cfg.streakWinProbThreshold = 0.5;

% ── Practice ─────────────────────────────────────────────────────────────
cfg.nPracticeTrials = 10;

% ── Keys ─────────────────────────────────────────────────────────────────
KbName('UnifyKeyNames');
cfg.keys.left   = KbName('LeftArrow');
cfg.keys.right  = KbName('RightArrow');
cfg.keys.escape = KbName('ESCAPE');
cfg.keys.space  = KbName('space');
end

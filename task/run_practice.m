function completed = run_practice(scr, cfg)
%RUN_PRACTICE  Run practice block (no streak enforcement, no data saved).
%
%   completed = run_practice(scr, cfg)
%
%   Returns:
%     completed = true  if practice finished normally
%     completed = false if Escape was pressed (main_task handles sca)

completed = true;

% ── Practice intro screen ─────────────────────────────────────────────────
Screen('FillRect', scr.win, scr.black);
practiceMsg = sprintf(['PRACTICE TRIALS\n\n' ...
    '%d practice trials to familiarize yourself with the task.\n\n' ...
    'These trials do NOT count toward your earnings.\n\n' ...
    'Press SPACE to begin.'], cfg.nPracticeTrials);
DrawFormattedText(scr.win, practiceMsg, 'center', 'center', scr.white);
Screen('Flip', scr.win);
wait_for_key(cfg.keys.space);

for p = 1:cfg.nPracticeTrials

    % Generate trial parameters
    firstNum  = randi([0, 9]);
    winProb   = (10 - firstNum) / 10;
    gambleAmt = cfg.gambleMin + randi([0, cfg.gambleMax - cfg.gambleMin]);
    safeLeft  = randi([0, 1]);

    % ── Fixation ──────────────────────────────────────────────────────────
    Screen('FillRect', scr.win, scr.black);
    DrawFormattedText(scr.win, '+', 'center', 'center', scr.white);
    tFix = Screen('Flip', scr.win);
    WaitSecs(cfg.timing.fixation - scr.ifi/2);

    % ── Game Presentation (no response) ───────────────────────────────────
    draw_game_screen(scr, cfg, safeLeft, cfg.safeReward, ...
        gambleAmt, firstNum, winProb, 0);
    tGame = Screen('Flip', scr.win);
    WaitSecs(cfg.timing.gamePresent - scr.ifi/2);

    % ── Decision Window ───────────────────────────────────────────────────
    draw_game_screen(scr, cfg, safeLeft, cfg.safeReward, ...
        gambleAmt, firstNum, winProb, 1);
    tDecision = Screen('Flip', scr.win);

    [choice, ~, aborted] = get_response(scr, cfg, tDecision, safeLeft);

    if aborted
        completed = false;
        return;
    end

    % ── Outcome (always free, no enforcement) ──────────────────────────────
    gambleChosen = (choice == 1);
    gambleWon    = false;
    secondNum    = NaN;

    if gambleChosen
        secondNum = draw_free_second(firstNum);
        gambleWon = (secondNum > firstNum);
    end

    draw_outcome(scr, cfg, choice, gambleChosen, gambleWon, ...
        gambleAmt, firstNum, secondNum);
    Screen('Flip', scr.win);
    WaitSecs(cfg.timing.outcome - scr.ifi/2);

    % ── ITI ───────────────────────────────────────────────────────────────
    Screen('FillRect', scr.win, scr.black);
    Screen('Flip', scr.win);
    WaitSecs(cfg.timing.iti - scr.ifi/2);
end

% ── Practice complete screen ──────────────────────────────────────────────
Screen('FillRect', scr.win, scr.black);
DrawFormattedText(scr.win, ...
    ['Practice complete!\n\n' ...
    'The MAIN TASK will now begin.\n\n' ...
    'Press SPACE to continue.'], ...
    'center', 'center', scr.white);
Screen('Flip', scr.win);
wait_for_key(cfg.keys.space);
end

% ── Helper ────────────────────────────────────────────────────────────────
function secondNum = draw_free_second(firstNum)
secondNum = randi([0, 9]);
while secondNum == firstNum
    secondNum = randi([0, 9]);
end
end

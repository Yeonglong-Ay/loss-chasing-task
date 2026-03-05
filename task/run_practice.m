function run_practice(scr, cfg)
%RUN_PRACTICE  Run practice block (no streak enforcement, no data saved).
%
%   run_practice(scr, cfg)

Screen('FillRect', scr.win, scr.black);
DrawFormattedText(scr.win, ...
    ['PRACTICE TRIALS\n\n' ...
     sprintf('%d practice trials — these do NOT count toward earnings.\n\n', ...
             cfg.nPracticeTrials) ...
     'Press SPACE to begin.'], ...
    'center', 'center', scr.white);
Screen('Flip', scr.win);
wait_for_key(cfg.keys.space);

for p = 1:cfg.nPracticeTrials
    firstNum  = randi([0, 9]);
    winProb   = (10 - firstNum) / 10;
    gambleAmt = cfg.gambleMin + randi([0, cfg.gambleMax - cfg.gambleMin]);
    safeLeft  = randi([0, 1]);

    % Fixation
    draw_fixation(scr, cfg);

    % Game presentation
    draw_game_screen(scr, cfg, safeLeft, cfg.safeReward, ...
                     gambleAmt, firstNum, winProb, 0);
    Screen('Flip', scr.win);
    WaitSecs(cfg.timing.gamePresent - scr.ifi / 2);

    % Decision
    draw_game_screen(scr, cfg, safeLeft, cfg.safeReward, ...
                     gambleAmt, firstNum, winProb, 1);
    flipT = Screen('Flip', scr.win);
    [choice, ~, aborted] = get_response(scr, cfg, flipT, safeLeft);

    if aborted; sca; return; end

    % Outcome — always free (no enforcement during practice)
    gambleChosen = (choice == 1);
    gambleWon    = false;
    secondNum    = NaN;

    if gambleChosen
        secondNum  = draw_free_second(firstNum);
        gambleWon  = (secondNum > firstNum);
    end

    draw_outcome(scr, cfg, choice, gambleChosen, gambleWon, ...
                 gambleAmt, firstNum, secondNum);

    % ITI
    Screen('FillRect', scr.win, scr.black);
    Screen('Flip', scr.win);
    WaitSecs(cfg.timing.iti - scr.ifi / 2);
end

Screen('FillRect', scr.win, scr.black);
DrawFormattedText(scr.win, ...
    'Practice complete!\n\nThe MAIN TASK will now begin.\n\nPress SPACE to continue.', ...
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

function [currentStreak, lastOutcome] = compute_streak(gambleChosen, ...
                                          gambleWon, missedResponse, ...
                                          currentStreak, lastOutcome)
%COMPUTE_STREAK  Update running consecutive loss streak counter.
%
%   [currentStreak, lastOutcome] = compute_streak(gambleChosen, gambleWon,
%       missedResponse, currentStreak, lastOutcome)
%
%   Inputs:
%     gambleChosen   - 1 if participant chose gamble
%     gambleWon      - 1 if gamble was won
%     missedResponse - 1 if no response was made
%     currentStreak  - streak count coming into this trial
%     lastOutcome    - 1=win, 0=loss, NaN=safe/missed on last trial
%
%   Outputs:
%     currentStreak  - updated streak count
%     lastOutcome    - updated last outcome flag

if gambleChosen && ~missedResponse
    if ~gambleWon
        % Extend or start loss streak
        if ~isnan(lastOutcome) && lastOutcome == 0
            currentStreak = currentStreak + 1;
        else
            currentStreak = 1;
        end
        lastOutcome = 0;
    else
        % Win resets streak
        currentStreak = 0;
        lastOutcome   = 1;
    end
else
    % Safe choice or missed: reset streak
    currentStreak = 0;
    lastOutcome   = NaN;
end
end

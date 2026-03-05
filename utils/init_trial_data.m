function trialData = init_trial_data(nTrials, subjectID, sessionNum, blockSeq)
%INIT_TRIAL_DATA  Preallocate trial data struct.
%
%   trialData = init_trial_data(nTrials, subjectID, sessionNum, blockSeq)

trialData = struct();
trialData.subjectID         = subjectID;
trialData.sessionNum        = sessionNum;
trialData.blockSequence     = blockSeq;

% Per-trial fields (preallocate as vectors)
fields = {'trialNum', 'blockNum', 'blockType', ...
    'winProbCue', 'gambleAmount', 'safeLeft', ...
    'choice', 'RT', 'outcomeFirstNum', 'outcomeSecondNum', ...
    'gambleWon', 'rewardEarned', 'streakLength', ...
    'isStreakEnforced', 'lostChase', 'missedResponse', ...
    'flipTime_fixation', 'flipTime_gamePresent', ...
    'flipTime_decision', 'flipTime_outcome'};

for f = 1:length(fields)
    trialData.(fields{f}) = nan(nTrials, 1);
end
end

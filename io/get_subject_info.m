function [subjectID, sessionNum] = get_subject_info()
%GET_SUBJECT_INFO  Prompt experimenter for subject ID and session number.
%
%   [subjectID, sessionNum] = get_subject_info()

subjectID  = input('Enter Subject ID (e.g., sub-01): ', 's');
sessionNum = input('Enter Session Number (1-4): ');

if isempty(subjectID)
    error('Subject ID cannot be empty.');
end
if ~isnumeric(sessionNum) || sessionNum < 1 || sessionNum > 4
    error('Session number must be between 1 and 4.');
end
end

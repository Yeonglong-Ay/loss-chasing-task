function [subjectID, sessionNum] = get_subject_info()
%GET_SUBJECT_INFO  Prompt for subject ID and session number.
%
%   [subjectID, sessionNum] = get_subject_info()

subjectID   = input('Enter Subject ID (e.g., sub-01): ', 's');
sessionNum  = input('Enter Session Number (1-4): ');
end

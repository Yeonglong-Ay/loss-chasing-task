function wait_for_key(targetKey)
%WAIT_FOR_KEY  Wait for a specific key press.
%
%   wait_for_key(targetKey)

KbReleaseWait;
while true
    [~, ~, keyCode] = KbCheck;
    if keyCode(targetKey)
        KbReleaseWait;
        return;
    end
end
end

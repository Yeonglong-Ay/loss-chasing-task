function wait_for_key(targetKey)
%WAIT_FOR_KEY  Block execution until a specific key is pressed and released.
%
%   wait_for_key(targetKey)
%
%   Input:
%     targetKey - KbName key code (e.g., cfg.keys.space)

KbReleaseWait;
while true
    [~, ~, keyCode] = KbCheck;
    if keyCode(targetKey)
        KbReleaseWait;
        return;
    end
end
end

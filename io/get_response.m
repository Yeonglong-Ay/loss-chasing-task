function [choice, RT, aborted] = get_response(scr, cfg, startTime, safeLeft)
%GET_RESPONSE  Collect button press during decision window.
%
%   [choice, RT, aborted] = get_response(scr, cfg, startTime, safeLeft)
%
%   Returns:
%     choice  =  0  (safe chosen)
%               1  (gamble chosen)
%              -1  (timed out)
%     RT      = reaction time in seconds (NaN if timed out)
%     aborted = true if Escape pressed

choice  = -1;
RT      = NaN;
aborted = false;

while (GetSecs - startTime) < cfg.timing.maxDecision
    [keyDown, keyTime, keyCode] = KbCheck;

    if keyDown
        if keyCode(cfg.keys.escape)
            aborted = true;
            return;
        end

        if keyCode(cfg.keys.left) || keyCode(cfg.keys.right)
            RT        = keyTime - startTime;
            choseLeft = keyCode(cfg.keys.left);

            % Map physical key to logical choice based on screen layout
            if safeLeft
                choice = double(~choseLeft);  % left=safe(0), right=gamble(1)
            else
                choice = double(choseLeft);   % left=gamble(1), right=safe(0)
            end
            return;
        end
    end
end
% Timed out — choice remains -1
end

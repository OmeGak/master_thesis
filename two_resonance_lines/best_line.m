function [r] = best_line(lines,r,xmue)
    if xmue >= 0
        r = min(lines(sign(lines-r) == sign(xmue)));
    else
        r = max(lines(sign(lines-r) == sign(xmue)));
    end
    
    if length(lines) == 1
        r = lines;
    end
end
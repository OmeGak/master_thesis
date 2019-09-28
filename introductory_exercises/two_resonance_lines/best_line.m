function [r] = best_line(lines,r,xmue)
    if xmue >= 0
        r = min(lines(sign(lines-r) == xmue));
    else
        r = max(lines(sign(lines-r) == xmue));
    end
end
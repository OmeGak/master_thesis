function [goto_end_of_loop,xstart,xnew] =  create_well(xmin,xmax,vmin,vmax,resonance_x)
    % sample uniformely, but not in given intervals
    xstart = xmin + (xmax-xmin)*rand;
    xnew = xstart;

    vmin = resonance_x + vmin;
    vmax = resonance_x + vmax;

    goto_end_of_loop = 1;
    for k=1:length(vmin)
        if (xstart >= vmin(k)) & (xstart <= vmax(k))
            goto_end_of_loop = 0;
            xnew = [];
        end
    end
end
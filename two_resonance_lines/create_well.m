function [goto_end_of_loop,xstart,photon_path] =  create_well(xmin,xmax,vmin,vmax,resonance_x,photon_path,phot)
    % sample uniformely, but not in given intervals
    xstart = xmin + (xmax-xmin)*rand;

    vmin = resonance_x + vmin;
    vmax = resonance_x + vmax;

    goto_end_of_loop = 1;
    for k=1:length(vmin)
        if (xstart >= vmin(k)) & (xstart <= vmax(k))
            goto_end_of_loop = 0;
        end
    end
    
    photon_path(1,phot) = xstart;
end
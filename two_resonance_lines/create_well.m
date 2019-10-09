function [xstart,goto_end_of_loop,deterministic_sampling_x] ...
    =  create_well(xmin,xmax,vmin,vmax,resonance_x,deterministic_sampling_x,nphot,xstart_Fortran)
    % sample uniformely, but not in given intervals (emission/absorption)
    
    if xstart_Fortran == 1
        xstart = xmax*rand;
        make_neg = rand;
        if make_neg >= 0.5
            xstart = -xstart;
        end
    else
        xstart = xmin + (xmax-xmin)*rand;
    end
    
    if deterministic_sampling_x >= 1 
        xstart = xmin + deterministic_sampling_x*(xmax-xmin)/nphot;
        deterministic_sampling_x = deterministic_sampling_x + 1;
    end

    vmin = resonance_x + vmin;
    vmax = resonance_x + vmax;

    goto_end_of_loop = 1;
    for k=1:length(vmin)
        if (xstart >= 0.99*vmin(k)) & (xstart <= 1.01*vmax(k))
%             display('manneke toch - emission line created')
            goto_end_of_loop = 0;
        end
    end
    
end
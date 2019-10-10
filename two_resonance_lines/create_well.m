function [xstart,goto_end_of_loop,deterministic_sampling_x] ...
    =  create_well(xmin,xmax,vmin,vmax,resonance_x,deterministic_sampling_x,nphot,xstart_Fortran,phot)
    % sample uniformely, but not in given intervals (emission/absorption)
    
%     if xstart_Fortran == 1
%         xstart = xmax*rand;
%         make_neg = rand;
%         if make_neg >= 0.5
%             xstart = -xstart;
%         end
%     else
        xstart = xmin + (xmax-xmin)*rand;
%     end
    
    if deterministic_sampling_x >= 1 
        xstart = xmin + deterministic_sampling_x*(xmax-xmin)/nphot;
        deterministic_sampling_x = deterministic_sampling_x + 1;
    end

    vmin = resonance_x + 0.99*vmin;
    vmax = resonance_x + 1.01*vmax;

    goto_end_of_loop = 1;
    for k=1:length(vmin)
        if (xstart >= vmin(k)) & (xstart <= vmax(k))
%             display('manneke toch - emission line created')
            goto_end_of_loop = 0;
        end
    end
    
    if xstart_Fortran == 1
        vmin = resonance_x + -1.01*vmax;
        vmax = resonance_x + -0.99*vmin;
        
        goto_end_of_loop = 1;
        for k=1:length(vmin)
            if (xstart >= -1.01*vmax(k)) & (xstart <= -0.99*vmin(k))
    %             display('manneke toch - emission line created')
                goto_end_of_loop = 0;
            end
        end
    end    
end
function [goto_end_of_loop,xstart,xnew] =  create_well(xmax,vmax,vmin,resonance_x)
    goto_end_of_loop = 0;      

    xstart = -rand*xmax;
    
    xrnd = rand;
    if xrnd > 0.5
        xnew = -xstart;
        goto_end_of_loop = 1;
    else 
        % simulation of the absorption
        xnew = [];        
        vmax1 = vmax;
        vmin1 = vmin;

        % aanpassing voor meerdere lijnen
        vmax1 = max(resonance_x + vmax1);
        vmin1 = min(resonance_x + vmin1);

        if (xstart <= vmin1) | (xstart >= vmax1)
            xnew = xstart;
            goto_end_of_loop = 1;
        end
    end
        
end
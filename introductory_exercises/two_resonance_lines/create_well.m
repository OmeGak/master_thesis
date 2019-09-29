function [goto_end_of_loop , xnew] =  create_well(xstart,vmax,vmin,goto_end_of_loop,xnew,resonance_x)
    % simulation of the absorption
    
    if goto_end_of_loop == 0              
        xnew = [];        
        vmax1 = vmax*0.99;
        vmin1 = vmin*1.01;
        
        % aanpassing voor meerdere lijnen
        vmax1 = max(resonance_x + vmax1);
        vmin1 = min(resonance_x + vmin1);
        
        if (xstart <= vmin1) | (xstart >= vmax1)
            xnew = xstart;
            goto_end_of_loop = 1;
        end
        
    end
end
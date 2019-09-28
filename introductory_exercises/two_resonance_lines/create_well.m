function [goto_end_of_loop , xnew] =  create_well(xstart,vmax,vmin,goto_end_of_loop,xnew,a)
    if goto_end_of_loop == 0
        xnew = [];        
        vmax1 = vmax*0.99;
        vmin1 = vmin*1.01;
        if (xstart >= a + vmax1) | (xstart <= a + vmin1)
            % no resonance possible
            xnew = xstart;
            goto_end_of_loop = 1;
        end
    end
end
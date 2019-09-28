function [goto_end_of_loop , xnew , xstart] =  sample_also_negative(xstart,vmax,vmin)
    goto_end_of_loop = 0;      

    xrnd = rand;
    if xrnd > 0.5
        xnew = -xstart;
        goto_end_of_loop = 1;
    else 
        xnew = [];
    end
end
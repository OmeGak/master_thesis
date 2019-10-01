function [goto_end_of_loop , xnew , xstart] =  sample_xstart(xmax)
    goto_end_of_loop = 0;      

    xstart = rand*xmax;
    
    xrnd = rand;
    if xrnd > 0.5
        xnew = -xstart;
        goto_end_of_loop = 1;
    else 
        xnew = [];
    end
end
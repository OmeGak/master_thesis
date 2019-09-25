function interaction_possibility =  interaction_possible(xstart,vmax,vmin)
    goto_end_of_loop = 0;
    xnew = 0;        

    xrnd = rand;
    if xrnd >= 0.5
        xstart = -xstart;
        xnew = xstart;
        goto_end_of_loop = 1;
    end

    vmax1 = vmax*0.99;
    vmin1 = vmin*1.01;
    if (xstart >= vmax1) | (xstart <= vmin1)
        % no resonance possible
        xnew = xstart;
        goto_end_of_loop = 1;
    end
    
    interaction_possibility = [goto_end_of_loop , xnew];
end
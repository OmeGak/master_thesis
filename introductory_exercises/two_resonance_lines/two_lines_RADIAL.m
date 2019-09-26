function two_lines_RADIAL(nphot , xk0 , alpha , beta , make_plot , save)   
    [nchan,vmax,vmin,deltax,freq,flux,b,xmax,rmax,nin,nout] = param_init(nphot,xk0,alpha,beta)

    % loop over all photons
    for phot = 1:nphot
        xstart = rand*xmax;

        [goto_end_of_loop,xnew] = interaction_possible(xstart,vmax,vmin)

        if (goto_end_of_loop == 0)    
            [xnew,nin] = make_scattering(xstart,beta,alpha,b,rmax,xk0,nin)    
        end

        % tally the photons
        nout = nout + 1;
        ichan = floor((xmax-xnew)/deltax)+1;
        flux(ichan) = flux(ichan) +1;
    end

    normalise_and_plot(nphot,nchan,nin,flux,make_plot,freq,save)   
end
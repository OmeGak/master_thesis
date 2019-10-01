function [freq, flux] = one_radial_line_beta_version(nphot,xk0,alpha,beta,make_plot,save,all_radial)   

    nbins = 100;
    [nchan,vmax,vmin,deltax,freq,flux,b,xmax,rmax,nin,nout] = param_init(nphot,xk0,alpha,beta,nbins);

    % loop over all photons
    total_number_scatterings = 0;
    for phot = 1:nphot
        xstart = rand*xmax;

        [goto_end_of_loop,xnew,xstart] = sample_also_negative(xstart,vmax,vmin);
        [goto_end_of_loop,xnew] = create_well(xstart,vmax,vmin,goto_end_of_loop,xnew,0);

        if (goto_end_of_loop == 0)     
            [xnew,nin] = make_scattering(xstart,beta,alpha,b,rmax,xk0,nin,all_radial);    
            total_number_scatterings = total_number_scatterings + 1;
        end

        % tally the photons
        nout = nout + 1;
        ichan = floor((xmax-xnew)/deltax)+1;
        flux(ichan) = flux(ichan) +1;
    end

    flux = normalise_and_plot(nphot,nchan,nin,flux,xmax,make_plot,freq,save);
    total_number_scatterings = total_number_scatterings/nphot
end
    
    
    
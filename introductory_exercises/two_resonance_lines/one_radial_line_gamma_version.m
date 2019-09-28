function [freq, flux]= one_radial_line_gamma_version(nphot,xk0,alpha,beta,make_plot,save,possibility_scattering,nbins)   

    [nchan,vmax,vmin,deltax,freq,flux,b,xmax,rmax,nin,nout] = param_init(nphot,xk0,alpha,beta,nbins);

    % loop over all photons
    total_number_scatterings = 0;
    for phot = 1:nphot
        xstart = xmax*rand;

        [goto_end_of_loop,xnew,xstart] = sample_also_negative(xstart,vmax,vmin);
        [goto_end_of_loop,xnew] = create_well(xstart,vmax,vmin,goto_end_of_loop,xnew,0);

        if (goto_end_of_loop == 0) & (possibility_scattering == 1)
            [xnew,nin] = make_scattering(xstart,beta,alpha,b,rmax,xk0,nin);    
            total_number_scatterings = total_number_scatterings + 1;
        end

        % tally the photons
        nout = nout + 1;
        ichan = floor((xmax-xnew)/deltax)+1;
        flux(ichan) = flux(ichan)+1;
    end

    flux = normalise_and_plot(nphot,nchan,nin,flux,xmax,make_plot,freq,save) ;
    total_number_scatterings = total_number_scatterings/nphot;
end
    
    
    
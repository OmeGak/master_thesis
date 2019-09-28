function flux = two_lines(nphot , xk0 , alpha , beta , make_plot ,resonance_x , save, nbins,possibility_scattering,multiple_scatterings)   
    [nchan,vmax,vmin,deltax,freq,flux,b,xmax,rmax,nin,nout] = param_init(nphot,xk0,alpha,beta,nbins);
    
    total_number_scatterings = 0;
    % loop over all photons
    for phot = 1:nphot
        xstart = rand*xmax;

        r_init = 0;
        last_scatter = 0;
        
        [goto_end_of_loop,xnew,xstart] = sample_also_negative(xstart,vmax,vmin);        
        for k = 1:length(resonance_x)
            [goto_end_of_loop,xnew] = create_well(xstart,vmax,vmin,goto_end_of_loop,xnew,resonance_x(k));
        end
        
        if (goto_end_of_loop == 0) & (possibility_scattering == 1)
            [xnew,r_new,nin,last_scatter] = make_scattering_multiple_lines(xstart,beta,alpha,b,rmax,xk0,nin,resonance_x,r_init);       
            total_number_scatterings = total_number_scatterings + 1;
            
            while (last_scatter == 0) & (multiple_scatterings == 1)
                [xnew,r_new,nin,last_scatter] = make_scattering_multiple_lines(xstart,beta,alpha,b,rmax,xk0,nin,resonance_x,r_new);   
                total_number_scatterings = total_number_scatterings + 1;
            end
        end

        % tally the photons
        nout = nout + 1;
        ichan = floor((xmax-xnew)/deltax)+1;
        flux(ichan) = flux(ichan) +1;        
    end

    flux = normalise_and_plot(nphot,nchan,nin,flux,xmax,make_plot,freq,save);
    total_number_scatterings = total_number_scatterings/nphot 
end
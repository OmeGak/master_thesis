function [freq, flux,total_number_scatterings,photon_path] = multiple_lines(nphot,xk0,alpha,beta,make_plot,...
        resonance_x,save,nbins,possibility_scattering,multiple_scatterings,...
        all_radial,radial_release,isotropic_scattering,Eddington_limb_darkening,plot_only_scattering,...
        random_number,case_number)  
    
    % set initial problem parameters
    [nchan,vmin,vmax,deltax,freq,flux,b,xmin,xmax,rmax,nin,nout,photon_path,nsc,expected_scattering_ratio] =  ...
            param_init(beta,nbins,resonance_x,case_number,nphot);
    rng(random_number);
     
    % loop over all photons
    for phot = 1:nphot
        r_init = 0;
        
        [goto_end_of_loop,xstart,xnew] = create_well(xmin,xmax,vmin,vmax,resonance_x);
        if plot_only_scattering == 0
            [nout,flux] = add_count_photon(xnew,nout,xmin,deltax,nchan,flux);
        end
        
        if (goto_end_of_loop == 0) & (possibility_scattering == 1)  
            photon_path(1,phot) = xstart;
%             xstart = abs(xstart);

            if radial_release == 1
                xmuestart = 1;
            elseif Eddington_limb_darkening == 1
                xmuestart = Eddington()
            else
                xmuestart = sqrt(rand);
            end
            photon_path(2,phot) = xmuestart;
            
            last_scatter = 0;
            [xnew,r_new,nin,last_scatter,xmueou,nsc,photon_path] = ...
                make_scattering(xstart,xmuestart,beta,alpha,b,rmax,xk0,nin,...
                resonance_x,r_init,all_radial,isotropic_scattering,nsc,photon_path,phot,case_number);       
            [nout,flux] = add_count_photon(xnew,nout,xmin,deltax,nchan,flux);

            photon_path(3,phot) = xnew;
            photon_path(4,phot) = r_new;
        end
    end

    flux = normalise_and_plot(nphot,nchan,flux,xmin,xmax,vmin,vmax,make_plot,freq,save,resonance_x);
    total_number_scatterings = nsc/nphot 
end
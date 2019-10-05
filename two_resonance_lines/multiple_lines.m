function [freq,flux,total_number_scatterings,photon_path] = multiple_lines(nphot,xk0,alpha,beta,make_plot,...
        resonance_x,save,nbins,possibility_scattering,multiple_scatterings,...
        all_radial,radial_release,isotropic_scattering,Eddington_limb_darkening,plot_only_scattering,...
        random_number,make_display)  
    
    % set initial problem parameters
    [nchan,vmin,vmax,deltax,freq,flux,b,xmin,xmax,rmax,...
            nin,nout,photon_path,nsc,expected_scattering_ratio] =  ...
                param_init(beta,nbins,resonance_x,nphot);
            
    rng(random_number);
    
    display('_____________________________________')
     
    % loop over all photons
    for phot = 1:nphot  
%         if make_display == 1
%             display('___________HERE WE GO____________')
%         end
        
        [goto_end_of_loop,xstart,photon_path] = create_well(xmin,xmax,vmin,vmax,resonance_x,photon_path,phot);
        
        if (plot_only_scattering == 0) & (goto_end_of_loop == 1)
            [nout,flux] = add_count_photon(xstart,nout,xmin,deltax,nchan,flux,make_display);
        end
        
        if (goto_end_of_loop == 0) & (possibility_scattering == 1)  
            
            [xmuestart, photon_path] = release_photon(photon_path,radial_release,Eddington_limb_darkening,phot);
            
            [xnew,r_new,nin,last_scatter,xmueou,nsc,photon_path] = ...
                make_scattering(xstart,xmuestart,beta,alpha,b,rmax,xk0,nin,...
                resonance_x,0,all_radial,isotropic_scattering,nsc,...
                photon_path,phot,0); 
            
            [nout,flux] = add_count_photon(xnew,nout,xmin,deltax,nchan,flux,make_display);
        else
            [nout,flux] = add_count_photon(xstart,nout,xmin,deltax,nchan,flux,make_display);
        end
    end

    flux = normalise_and_plot(nphot,nchan,flux,xmin,xmax,vmin,vmax,make_plot,freq,save,resonance_x);
    total_number_scatterings = nsc/nphot; 
end
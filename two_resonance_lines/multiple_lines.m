function [freq,flux,total_number_scatterings,photon_path,yes,luminosity,rmax,total_number_backscatterings,dLdr,g_radiation]...
    = multiple_lines(nphot,alpha,beta,make_plot,...
        resonance_x,resonance_tau,save,nbins,nrbins,possibility_scattering,multiple_scatterings,...
        all_radial,radial_release,isotropic_scattering,Eddington_limb_darkening,plot_only_scattering,...
        random_number,track_path,number_paths,make_save,compare_Fortran,...
        deterministic_sampling_x,xstart_Fortran)  
    
    clc
    rng(random_number);
%     s = rng;
    
    % set initial problem parameters
    [nchan,vmin,vmax,deltax,freq,flux,b,xmin,xmax,rmax,rmin,...
            nin,nout,photon_path,nsc,~,luminosity,count_neg_phot,nphot] =  ...
                param_init(beta,nbins,nrbins,resonance_x,compare_Fortran,nphot);               
            
    display('_____________________________________')
     
    yes = zeros(4,nphot);
    % loop over all photons
    for phot = 1:nphot  
        phot_nsc = 0;
        forget_photon = 0;
        r_new = rmin;
        
        % select xstart
        [xstart,xnew,goto_end_of_loop,deterministic_sampling_x] = ...
            create_well(xmin,xmax,vmin,vmax,resonance_x,deterministic_sampling_x,nphot,xstart_Fortran,phot);
        [xmuestart, xmueou, one_photon_path] = release_photon(xstart,radial_release,Eddington_limb_darkening);
                
        % ALL SCATTERING EVENTS
        last_scatter = 0;
        r_init = rmin;
        while (last_scatter == 0) & (goto_end_of_loop == 0) & (possibility_scattering == 1)                    
            [xnew,r_new,nin,last_scatter,xmueou,phot_nsc,one_photon_path,forget_photon,...
                x_selected,luminosity] = ...
                    make_scattering(xstart,xmuestart,r_init,beta,alpha,b,rmax,nin,...
                        resonance_x,resonance_tau,all_radial,isotropic_scattering,phot_nsc,...
                        one_photon_path,vmin,vmax,xstart_Fortran,luminosity,nrbins);
            
            last_scatter = secundary_resonance_possible(xnew,resonance_x,vmin,vmax,last_scatter);
            xstart = xnew; xmuestart = xmueou; r_init = r_new;
        end
        
        [nout,flux] = add_count_photon(xnew,xstart,nout,xmin,deltax,nchan,flux,r_new,plot_only_scattering,forget_photon);
        nsc = nsc + phot_nsc; 
        photon_path = adjust_one_photon_path(photon_path,one_photon_path);
        
        % update luminosity for photons after their last scattering event
        [luminosity,count_neg_phot] = update_luminosity(xmueou , r_new , rmax , rmin , nrbins , luminosity , count_neg_phot);

    end
    
    % compute finite difference derivative of luminosity
    dr = (rmax-rmin)/nrbins;
    dLdr = diff(luminosity)/dr;
    
    r_array = linspace(1,rmax,nrbins-1);
    v = (1-b)^beta;
    Mdot = 4*pi*r_array.^2*v;
    g_radiation = -1./Mdot.*dLdr;
    
    % make plots and figures
    flux = normalise_and_plot(nphot,nchan,flux,xmin,xmax,vmin,vmax,...
        make_plot,freq,save,resonance_x,all_radial,radial_release,xstart_Fortran);   
    plot_track_path(photon_path,track_path,b,number_paths,make_save,rmax);
    
    % make some statistics
    total_number_scatterings = nsc/nphot
    total_number_backscatterings = nin/nphot
    backstreaming_phot = count_neg_phot/nphot
    
end
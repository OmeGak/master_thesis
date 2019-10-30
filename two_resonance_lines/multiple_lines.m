function [freq,flux,total_number_scatterings,photon_path,yes,luminosity,rmax,total_number_backscatterings,...
    dLdr,g_radiation,scattering_x,forgotten_photons,luminosity_min]...
    = multiple_lines(nphot,alpha,beta,make_plot,...
        resonance_x,resonance_tau,save,nbins,nrbins,possibility_scattering,multiple_scatterings,...
        all_radial,radial_release,isotropic_scattering,Eddington_limb_darkening,plot_only_scattering,...
        random_number,track_path,number_paths,make_save,compare_Fortran,...
        deterministic_sampling_x,xstart_Fortran,only_positive_xmueou)  
    
    clc
    rng(random_number);
%     s = rng;
    
    % set initial problem parameters
    [nchan,vmin,vmax,deltax,freq,flux,b,xmin,xmax,rmax,rmin,...
            nin,nout,photon_path,nsc,~,luminosity,count_neg_phot,nphot,nsc_real] =  ...
                param_init(beta,nbins,nrbins,resonance_x,compare_Fortran,nphot);               
    luminosity_min = luminosity;        
            
    display('_____________________________________')
     
    yes = zeros(4,nphot);
    scattering_x = [];
    forgotten_photons = 0;
    % loop over all photons
    for phot = 1:nphot  
        display('***** phot *****')
        display(phot)
        
        phot_nsc = 0;
        phot_nsc_real = 0;
        forget_photon = 0;
        r_new = rmin;
        forget_photon = 0;
        
        % select xstart
        [xstart,xnew,goto_end_of_loop,deterministic_sampling_x] = create_well(xmin,xmax,vmin,vmax,resonance_x,deterministic_sampling_x,nphot,xstart_Fortran,phot);
        [xmuestart, xmueou, one_photon_path] = release_photon(xstart,radial_release,Eddington_limb_darkening,goto_end_of_loop);
         
        last_scatter = 0;
        r_init = rmin;
        tau_decides_no_scatter_x = max(resonance_x) + vmax + 1;
        while (last_scatter == 0) & (goto_end_of_loop == 0) & (possibility_scattering == 1) & (forget_photon == 0)
            [xnew,r_new,nin,last_scatter,xmueou,phot_nsc,one_photon_path,forget_photon,luminosity,phot_nsc_real,...
                tau_decides_no_scatter_x,luminosity_min] = ...
                    make_scattering(xstart,xmuestart,r_init,beta,alpha,b,rmax,nin,...
                        resonance_x,resonance_tau,all_radial,isotropic_scattering,phot_nsc,...
                        one_photon_path,vmin,vmax,xstart_Fortran,luminosity,nrbins,phot_nsc_real,...
                        tau_decides_no_scatter_x,phot,only_positive_xmueou,luminosity_min);
            
            last_scatter = secundary_resonance_possible(xnew,resonance_x,vmin,vmax,last_scatter);
            xstart = xnew; 
            xmuestart = xmueou; 
            r_init = r_new;
        end
        
        [nout,flux] = add_count_photon(xnew,xstart,nout,xmin,deltax,nchan,flux,r_new,plot_only_scattering,forget_photon,goto_end_of_loop);
        nsc = nsc + phot_nsc; 
        nsc_real = nsc_real + phot_nsc_real;
        [photon_path,scattering_x] = adjust_one_photon_path(photon_path,one_photon_path,scattering_x,phot);
        
        % update luminosity for photons after their last scattering event
        [luminosity,count_neg_phot,luminosity_min] = update_luminosity(xmueou , r_new , rmax , rmin , nrbins , luminosity , count_neg_phot , ...
            goto_end_of_loop, forget_photon,phot,luminosity_min);

        if forget_photon == 1
            forgotten_photons = forgotten_photons + 1;
        end
        
    end  
    display('****** all photons are handled *****')
    
    % compute finite difference derivative of luminosity
    dr = (rmax-rmin)/nrbins;
    luminosity_tot = luminosity - luminosity_min;
    dLdr = diff(luminosity_tot)/dr;
    
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
    total_number_scatterings_real = nsc_real/nphot
    total_number_backscatterings = nin/nphot
    backstreaming_phot = count_neg_phot/nphot
    
    display('____________________________________')
    
end
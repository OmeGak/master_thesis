function [freq,flux,total_number_scatterings,photon_path,yes,luminosity,rmax,total_number_backscatterings,...
    dLdr,g_radiation,scattering_x,forgotten_photons,luminosity_min]...
    = test_file(test_number)   
    % SET ALL PARAMETERS  
    [make_save,nphot,alpha,beta,nbins,nrbins,possibility_scattering,resonance_x,resonance_tau,multiple_scatterings,...
            all_radial,radial_release,Eddington_limb_darkening,isotropic_scattering,...
            plot_only_scattering,random_number,make_display,track_path,number_paths,...
            compare_Fortran,deterministic_sampling_x,xstart_Fortran,make_plot,only_positive_xmueou] ...
            = get_default_params()
    
    % OVERVIEW OF TESTS !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!        
    if test_number == 0
        nphot = 10^2
        xk0 = 100;
        track_path = 0;
        number_paths = min(nphot,100);  
                         
    elseif test_number == 21
        resonance_x = [-0.5,0];
        resonance_tau = 100*ones(1,2); 

        track_path = 1;
        number_paths = 100;          
                   
   
    % EXERCISE TESTS        
    elseif test_number == 1
        % first adaptation: radial release
        radial_release = 1; 

    elseif test_number == 2
        % isotropic scattering --> higher peak
        isotropic_scattering = 1;

    elseif test_number == 3    
        % Eddington limb darkening 
        Eddington_limb_darkening = 1;

    elseif test_number == 4
        % photospheric line-profile 
        % ???
        
    % OTHER TESTS
        
    % many (!) lines        
    elseif test_number == 500
        resonance_x = [-4,-3.2,-3,-0.5,0,4,6,7,8.2];
        resonance_tau = 100*ones(1,length(resonance_x));
        multiple_scatterings = 1;  

        track_path = 1;
        number_paths = 25;      
    end
    
    [freq,flux,total_number_scatterings,photon_path,yes,luminosity,rmax,total_number_backscatterings,...
    dLdr,g_radiation,scattering_x,forgotten_photons,luminosity_min]...
        = multiple_lines(nphot,alpha,beta,...
        make_plot,resonance_x,resonance_tau,make_save,nbins,nrbins,...
        possibility_scattering,multiple_scatterings,all_radial,radial_release,isotropic_scattering,...
        Eddington_limb_darkening,plot_only_scattering,random_number,...
        track_path,number_paths,make_save,compare_Fortran,...
        deterministic_sampling_x,xstart_Fortran,only_positive_xmueou); 
    
    if make_save == 1
        if test_number == 11
            saveas(gcf,'figures/scattering_distribution_radial_release.png')
        elseif test_number == 111
            saveas(gcf,'figures/scattering_distribution_random_release.png')
        end
    end

end

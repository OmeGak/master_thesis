function [freq, flux_two, number_scatterings,photon_path,yes,luminosity,rmax] = test_file(test_number)   
    % SET ALL PARAMETERS  
    make_save = 0;
    
    nphot = 10^5
    alpha = 0;
    beta = 1;
    nbins = 100;

    possibility_scattering = 1;
    
    resonance_x = [0];
    resonance_tau = [100];
        
    multiple_scatterings = 0;

    all_radial = 0;
    % release
    radial_release = 0;
    Eddington_limb_darkening = 0;
    
    % scattering
    isotropic_scattering = 0;
    plot_only_scattering = 0;

    random_number = 10;
    
    make_display = 0;
    track_path = 0;
    number_paths = 10;
    compare_Fortran = 0;
    deterministic_sampling_x = 0;
    
    xstart_Fortran = 0;
    
    
    % OVERVIEW OF TESTS
    if test_number == 0
        % original version 
            % (by default, compare_Fortran = 1)
            nphot = 10^5;
            
    elseif test_number == 100
        % original version 
            % (by default, compare_Fortran = 1)
            xstart_Fortran = 1;
            nphot = 10^5;
            
    elseif test_number == 101
        % original version 
            % (by default, compare_Fortran = 1)
            xstart_Fortran = 1;
            nphot = 10^5;            
   
            
            

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
    % test formation of line at another location
        elseif test_number == 5
            resonance_x = [-2,0]
            possibility_scattering = 1;
%             plot_only_scattering = 1;
            
    
    % test creation of well
        elseif test_number == 5
            % simple well
            possibility_scattering = 0;     

        elseif test_number == 6
            % simple well
            resonance_x = [-2,0];
            resonance_tau = [100,100];
            possibility_scattering = 1; 
            multiple_scatterings = 0;
            
            
    % test formation of two lines        
        elseif test_number == 7
            % only radially streaming photons (thus also radial release)
            resonance_x = [0];
            multiple_scatterings = 0;
            all_radial = 1;
            radial_release = 1; 
            track_path = 1;

        elseif test_number == 8
            % formation of two lines, with radial release
            resonance_x = [0,0.5];
            all_radial = 0;
            radial_release = 1;    
            multiple_scatterings = 1;
        
    % test radial release    
        elseif test_number == 11
            resonance_x = 0;
            isotropic_scattering = 1;
            multiple_scatterings = 0;
            plot_only_scattering = 1;
            radial_release = 1;        

        elseif test_number == 111
            resonance_x = 0;
            isotropic_scattering = 1;
            multiple_scatterings = 0;  
            plot_only_scattering = 1;
            radial_release = 0;      
        
    % test multiple_scatterings        
        elseif test_number == 15
            resonance_x = [0,0.5];
            resonance_tau = [100,100];
            plot_only_scattering = 0;
            make_display = 1       
            multiple_scatterings = 0
            
        elseif test_number == 16
            resonance_x = [0,0.5];
            resonance_tau = [100,100];
            plot_only_scattering = 0;
            make_display = 1 
            multiple_scatterings = 1
        
    % test location of resonance frequencies
    elseif test_number == 17
        resonance_x = [-2,0];
        plot_only_scattering = 0;
        make_display = 1 
         
    % test superposition in absence of multiple_scatterings     
        elseif test_number == 18
            resonance_x = [-2];
            resonance_tau = [100];
            multiple_scatterings = 0;

        elseif test_number == 19
            resonance_x = [0];
            resonance_tau = [100];
            multiple_scatterings = 0;      

        elseif test_number == 20
            resonance_x = [-2,0];
            resonance_tau = [100,100];
            multiple_scatterings = 0;        

    % test superposition in with multiple_scatterings     
        elseif test_number == 180
            resonance_x = [-2];
            resonance_tau = [100,100];
            multiple_scatterings = 1;

        elseif test_number == 190
            resonance_x = [0];
            resonance_tau = [100,100];
            multiple_scatterings = 1;      

        elseif test_number == 200
            resonance_x = [-2,0];
            resonance_tau = [100,100];
            multiple_scatterings = 1; 
     
    % test track_path        
        elseif test_number == 21
            resonance_x = [-0.5,0];
            resonance_tau = [100,100];
            make_display = 0; 
            track_path = 1;
            multiple_scatterings = 1;
            radial_release = 1;
            number_paths = 25;     
       
    % test multiple opacites   [numbers -- 30]      
        elseif test_number == 30
            resonance_tau = 100;

        elseif test_number == 31
            resonance_tau = 0.5;   
            
        elseif test_number == 32
            resonance_tau = 0.05;  
            plot_only_scattering = 1; 
            
            
    end

    make_plot = 1;
    make_save = 1;
    compare_Fortran = 1         % this affects the problem parameters

    % determine L(r)
    nrbins = 100;
    
    [freq, flux_two,number_scatterings,photon_path,yes,luminosity,rmax]...
        = multiple_lines(nphot,alpha,beta,...
        make_plot,resonance_x,resonance_tau,make_save,nbins,nrbins,...
        possibility_scattering,multiple_scatterings,all_radial,radial_release,isotropic_scattering,...
        Eddington_limb_darkening,plot_only_scattering,random_number,...
        track_path,number_paths,make_save,compare_Fortran,...
        deterministic_sampling_x,xstart_Fortran); 
    
    if make_save == 1
        if test_number == 11
            saveas(gcf,'figures/scattering_distribution_radial_release.png')
        elseif test_number == 111
            saveas(gcf,'figures/scattering_distribution_random_release.png')
        end
    end

end

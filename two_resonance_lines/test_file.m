function [freq, flux_two, number_scatterings,photon_path] = test_file(test_number)
    clc, close all

    make_save = 0;
    
    nphot = 10^3
    xk0 = 100
    alpha = 0
    beta = 1
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

    % HERE WE GO !!!
    if test_number == 0
        % original version

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
    
        
        
    elseif test_number == 5
        % simple well
        possibility_scattering = 0;     
    
    elseif test_number == 6
        % simple well
        resonance_x = [0,-0.5];
        possibility_scattering = 0; 
        
    elseif test_number == 7
        % formation of two lines, only radially streaming photons (thus also
        % radial release)
        resonance_x = [0,0.5];
        multiple_scatterings = 1;
        all_radial = 1;
        radial_release = 1;    

    elseif test_number == 8
        % formation of two lines, with radial release
        resonance_x = [0,0.5];
        all_radial = 0;
        radial_release = 1;    
        multiple_scatterings = 1;
        
    elseif test_number == 9
        % formation of three lines, full scattering possibilities
        resonance_x = [0];
        multiple_scatterings = 1;

    elseif test_number == 10
        resonance_x = 0;
        isotropic_scattering = 1;
        radial_release = 1;
        plot_only_scattering = 0;
        multiple_scatterings = 0;

    elseif test_number == 11
        resonance_x = 0;
        isotropic_scattering = 1;
        radial_release = 1;
        plot_only_scattering = 1;
        multiple_scatterings = 0;
        
    elseif test_number == 12
        resonance_x = [0];
        possibility_scattering = 1;
        isotropic_scattering = 1;

    elseif test_number == 13
        resonance_x = [0];
        resonance_tau = 100;
        plot_only_scattering = 0;
        make_display = 1

    elseif test_number == 14
        resonance_x = [0.5];
        plot_only_scattering = 0;
        make_display = 1    
        
    elseif test_number == 15
        resonance_x = [0,0.5];
        resonance_tau = [100,100];
        plot_only_scattering = 0;
        make_display = 1 

    elseif test_number == 16
        resonance_x = [-2,0];
        plot_only_scattering = 0;
        make_display = 1 
 
    elseif test_number == 17
        resonance_x = [-2,0];
        plot_only_scattering = 0;
        make_display = 1         
        track_path = 1;
        
    elseif test_number == 18
        resonance_x = [-0.5,0];
        resonance_tau = [100,100];
        plot_only_scattering = 0;
        make_display = 1; 
        track_path = 1;
       
    elseif test_number == 19
        multiple_scatterings = 1;
        
    elseif test_number == 20
        resonance_x = [-0.5,0];
        resonance_tau = [100,100];
        make_display = 0; 
        track_path = 1;
        multiple_scatterings = 0;
        radial_release = 1;

    elseif test_number == 21
        resonance_x = [-0.5,0];
        resonance_tau = [100,100];
        make_display = 0; 
        track_path = 1;
        multiple_scatterings = 1;
        radial_release = 1;
        isotropic_scattering = 1;
        number_paths = 18;
        make_save = 1;
        
    end

    make_plot = 1
    make_save = 1 

    [freq, flux_two,number_scatterings,photon_path] = multiple_lines(nphot,xk0,alpha,beta,...
        make_plot,resonance_x,resonance_tau,make_save,nbins,possibility_scattering,...
        multiple_scatterings,all_radial,radial_release,isotropic_scattering,...
        Eddington_limb_darkening,plot_only_scattering,random_number,make_display,track_path,number_paths,make_save);
end

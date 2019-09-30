function [freq, flux_two, number_scatterings,photon_path] = test_file(test_number)
    clc, close all

    nphot = 10^5
    xk0 = 100
    alpha = 0
    beta = 1
    nbins = 100;

    possibility_scattering = 1;
    
    resonance_x = [0];
    multiple_scatterings = 0;

    all_radial = 0;
    radial_release = 0;
    
    isotropic_scattering = 0;
    Eddington_limb_darkening = 0;
    
    if test_number == 0
        % original version

    elseif test_number == 1
        % first adaptation: radial release
        radial_release = 1; 

    elseif test_number == 2
        % isotropic scattering --> higher peak
        radial_release = 0;

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
        resonance_x = [0.5];
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
        % formation of two lines, limited scattering possibilities
        resonance_x = [0,-0.5];
        multiple_scatterings = 0;
        
    elseif test_number == 9
        % formation of three lines, full scattering possibilities
        resonance_x = [0,-0.5];
        multiple_scatterings = 1;

    end

    make_plot = 1
    make_save = 1 

    [freq, flux_two,number_scatterings,photon_path] = multiple_lines(nphot,xk0,alpha,beta,...
        make_plot,resonance_x,make_save,nbins,possibility_scattering,...
        multiple_scatterings,all_radial,radial_release,isotropic_scattering,...
        Eddington_limb_darkening);
end

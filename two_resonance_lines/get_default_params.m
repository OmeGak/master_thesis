function [make_save,nphot,alpha,beta,nbins,nrbins,possibility_scattering,resonance_x,resonance_tau,multiple_scatterings,...
            all_radial,radial_release,Eddington_limb_darkening,isotropic_scattering,...
            plot_only_scattering,random_number,make_display,track_path,number_paths,...
            compare_Fortran,deterministic_sampling_x,xstart_Fortran,make_plot,only_positive_xmueou] ...
            = get_default_params()
    
    nphot = 10^5
    alpha = 0;
    beta = 1;
    nbins = 100;
    nrbins = 100;

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
    number_paths = 30;
    
    compare_Fortran = 0;
    deterministic_sampling_x = 0;   
    xstart_Fortran = 0;
    
    make_plot = 1;
    make_save = 0;
    compare_Fortran = 1         
    
    only_positive_xmueou = 0;
end
function [nchan,vmin,vmax,deltax,freq,flux,b,xmin,xmax,rmax,rmin,...
        nin,nout,photon_path,nsc,expected_scattering_ratio,luminosity,...
        count_neg_phot,nphot,nsc_real] ...
        = param_init(beta,nbins,nrbins,resonance_x,compare_Fortran,nphot) 
    % xmin and xmax are the boundaries of the frequency interval
    % vmin and vmax are the boundaries of the absorption regions   
    
    if compare_Fortran == 1
        xmin = min(resonance_x - 1.1);
        xmax = max(resonance_x + 1.1);

            vmin = -0.98;
            vmax = -0.01;
            
            b = 1+vmax^(1/beta);
            rmax = b/(1+vmin^(1/beta));    
            rmin = 1; 
    end
    
    nchan = nbins;
    deltax = (xmax-xmin)/nchan;

    flux = zeros(1,nchan);
    freq = linspace(xmin+0.5*deltax,xmax-0.5*deltax,nchan);

    nin = 0;
    nout = 0;

    photon_path = [];
    nsc = 0;
    
    forget_photon = 0;
    

    % compute expected_scattering_ratio
    expected_scattering_ratio = abs(0.99*vmin-1.01*vmax);
    for k=1:length(resonance_x)- 1
        if resonance_x(k) + abs(vmin-vmax) < resonance_x(k+1)
            expected_scattering_ratio = expected_scattering_ratio + abs(vmin-vmax);
        else
            expected_scattering_ratio = expected_scattering_ratio + abs(resonance_x(k) - resonance_x(k+1));
        end
    end
    expected_scattering_ratio = expected_scattering_ratio/(xmax-xmin)
    if min(diff(resonance_x)) < 0.98
        overlap = min(diff(resonance_x))/abs(min(resonance_x-0.98)-max(resonance_x+0.98));
        expected_scattering_ratio = expected_scattering_ratio*(1+overlap)
    end
    
    r_array = linspace(1,rmax,nrbins);
    luminosity = zeros(1,nrbins);
    count_neg_phot = 0;
    
    nphot = nphot*length(resonance_x);
    
    nsc_real = 0;
    
end
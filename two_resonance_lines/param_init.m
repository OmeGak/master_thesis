function [nchan,vmin,vmax,deltax,freq,flux,b,xmin,xmax,rmax,nin,nout,photon_path,nsc,expected_scattering_ratio] ...
        = param_init(beta,nbins,resonance_x,nphot) 
    % xmin and xmax are the boundaries of the frequency interval
    % vmin and vmax are the boundaries of the absorption regions

    xmin = min(resonance_x - 1)
    xmax = max(resonance_x + 1)
    
        vmin = -0.8;
        vmax = 0;
        b = 1+vmax^(1/beta);
        rmax = b/(1+vmin^(1/beta));

    nchan = nbins;
    deltax = (xmax-xmin)/nchan;

    flux = zeros(1,nchan);
    freq = linspace(xmin,xmax,nchan);

    nin = 0;
    nout = 0;

    photon_path = zeros(1,nphot);
    nsc = 0;

    expected_scattering_ratio = (max(resonance_x + vmax)-min(resonance_x + vmin))/(2*xmax)
end
function [nchan,vmin,vmax,deltax,freq,flux,b,xmax,rmax,nin,nout] = param_init(beta,nbins)   
    xmax = 1;
    
    vmin = -0.8;
    vmax = 0;
    
    b = 1-vmin^(1/beta);
    rmax = b/(1-vmax^(1/beta));

    nchan = nbins;
    deltax = 2*xmax/nchan;
    flux = zeros(1,nchan);
    freq = linspace(-xmax,xmax,nchan);

    nin = 0;
    nout = 0;
end
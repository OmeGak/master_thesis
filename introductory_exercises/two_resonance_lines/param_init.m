function [nchan,vmax,vmin,deltax,freq,flux,b,xmax,rmax,nin,nout] = param_init(beta,nbins)
    
    nchan = nbins;
    xmax = 1.1;
    
    vmax = 0.98;
    vmin = 0.01;

    deltax = 2*xmax/nchan;
    flux = zeros(1,nchan);
    freq = linspace(-xmax,xmax,nchan);

    b = 1-vmin^(1/beta);
    rmax = b/(1-vmax^(1/beta));

    nin = 0;
    nout = 0;
end
function [nchan,vmax,vmin,deltax,freq,flux,b,xmax,rmax,nin,nout] = param_init(beta,nbins)   
    xmax = 1.1;
   
    vmax = 0.98;
    vmin = -0.5;
    
%     vmax = -0.01;
%     vmin = -0.98;
    
    b = 1-vmin^(1/beta);
    rmax = b/(1-vmax^(1/beta));

    nchan = nbins;
    deltax = 2*xmax/nchan;
    flux = zeros(1,nchan);
    freq = linspace(-xmax,xmax,nchan);

    nin = 0;
    nout = 0;
end
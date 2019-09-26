function [nchan,vmax,vmin,deltax,freq,flux,b,xmax,rmax,nin,nout] = param_init(nphot,xk0,alpha,beta)
    nchan = 100;

    xmax = 1.1;
    vmin = 0.01;

    deltax = 2*xmax/nchan;
    freq = zeros(1,nchan);
    flux = zeros(1,nchan);
    freq(1) = xmax-5*deltax;
    for n=1:nchan
        freq(n) = freq(1)-(n-1)*deltax;
    end

    b = 1-vmin^(1/beta);
    vmax = 0.98;
    rmax = b/(1-vmax^(1/beta));

    nin = 0;
    nout = 0;
end
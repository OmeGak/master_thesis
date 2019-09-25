function xmueout = xmueout(xk0,alpha,r,v,sigma)
    tau0 = xk0/(r*v^(2-alpha));
    f3 = min(1,max((1+sigma)/tau0,1/tau0));
    
    y0 = 2;
    px = 1;
    while y0 > px
        x0 = rand;
        tau = tau0/(1+x0^2*sigma);
        y0 = f3*rand;
        px = (1-exp(-tau))/tau;
    end
    
    xmueout = x0;
end
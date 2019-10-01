function xmueout = xmueout(xk0,alpha,r,v,sigma,all_radial)
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
    
    if all_radial == 1
        x = rand;
        if x < 0.5
            xmueout = -1;
        else
            xmueout = 1;
        end
    end
end
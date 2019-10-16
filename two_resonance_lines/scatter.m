function [xnew,xmueou,forget_photon,nin] ...
    = scatter(xstart,tau_selected,xmuestart,r,b,beta,alpha,all_radial,nsc,isotropic_scattering,nin)  

        forget_photon = 0;
        
        xk0 = tau_selected;

        pstart = sqrt(1-xmuestart^2);
        xmuein = sqrt(1-(pstart/r)^2);
        v = (1-b/r)^(beta);
        dvdr = b*beta/r^2*(1-b/r)^(beta-1);
        sigma = dvdr/(v/r)-1;
        tau = xk0/(r*v^(2-alpha)*(1+xmuein^2*sigma));

        if tau > -log(rand)
            nsc = nsc + 1;
            
            xmueou = xmueout(xk0,alpha,r,v,sigma,all_radial);
            
            if isotropic_scattering == 1
                xmueou = 2*rand-1;
            end
            
            % make symmetric distribution
            if rand >= 0.5
                xmueou = -xmueou;
                if sqrt(r^2*(1-xmueou^2)) <= 1
                    nin = nin +1;
                    forget_photon = 1;
                end
            end
        else        
            xmueou = xmuein;
        end
        xnew = xstart - v*(xmueou-xmuein);
end
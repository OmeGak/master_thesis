function [xnew,xmueou,last_scatter] = scatter(xstart,x_selected,tau_selected,xmuestart,r,b,beta,alpha,all_radial,nsc,isotropic_scattering,nin)  

        forget_photon = 0;
        last_scatter = 0;
        
        xk0 = tau_selected;

        pstart = sqrt(1-xmuestart^2);
        xmuein = sqrt(1-(pstart/r)^2);
        v = (1-b/r)^(beta);
        dvdr = b*beta/r^2*(1-b/r)^(beta-1);
        sigma = dvdr/(v/r)-1;
        tau = xk0/(r*v^(2-alpha)*(1+xmuein^2*sigma));

        if tau >= rand
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
                    % FORGET PHOTON !!!
                    forget_photon = 1;
                end
            end
        else        
            xmueou = xmuein;
            last_scatter = 1;
        end
        xnew = -xstart + 2*x_selected + v*(xmueou-xmuein);
        
        if forget_photon == 1
            xnew = [];
            last_scatter = 1;
        end
end
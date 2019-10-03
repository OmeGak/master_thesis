function [xnew,xmueou] = scatter(xstart,xmuestart,r,b,xk0,beta,alpha,all_radial,nsc,isotropic_scattering,nin,case_number)
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
            
            % make xmueou symmetric
            if rand >= 0.5
                xmueou = -xmueou;
                if sqrt(r^2*(1-xmueou^2)) <= 1
                    nin = nin +1;
                end
            end
        else
            xmueou = xmuein;
            last_scatter = 1;
        end
        xnew = xstart + v*(xmueou-xmuein);
        if case_number == 2
            xnew = xstart - v*(xmueou-xmuein);
        end
end
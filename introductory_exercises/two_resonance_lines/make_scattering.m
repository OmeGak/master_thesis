function [xnew,nin] =  make_scattering(xstart,beta,alpha,b,rmax,xk0,nin)
        xmuestart = 1;
        pstart = sqrt(1-xmuestart^2);
        r_anal = b/(1-xstart^(1/beta))
        r = max(1,min(r_anal,rmax))
        xmuein = 1;
        v = (1-b/r)^(beta);
        dvdr = b*beta/r^2*(1-b/r)^(beta-1);
        sigma = dvdr/(v/r)-1;
        tau = xk0/(r*v^(2-alpha)*(1+xmuein^2*sigma));

        if tau >= rand
            xmueou = xmueout(xk0,alpha,r,v,sigma);

            if rand >= 0.5
                xmueou = -xmueou;
                pcheck = sqrt(r^2*(1-xmueou^2));
                if pcheck <= 1
                    nin = nin +1;
                end
            end

            xnew = xstart + v*(xmueou-xmuein);

        else
            xnew = xstart;
        end  
end
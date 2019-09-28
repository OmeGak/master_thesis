function [xnew,r,nin,last_scatter] =  make_scattering_multiple_lines(xstart,beta,alpha,b,rmax,xk0,nin,resonance_x,r_init)
        last_scatter = 0;

        xmuestart = 1;
        pstart = sqrt(1-xmuestart^2);
        
        % all scattering possibilities
        r_collection = zeros(1,length(resonance_x));
        for k = 1:length(resonance_x)
            a = resonance_x(k);
            
            r_anal = b/(1-(xstart-a)^(1/beta));
            r = max(1,min(r_anal,rmax));

            func = @(r) sqrt(1-(pstart/r)^2)*(1-b/r)^beta - xstart - a;
            r_num = rtbis(func , 1 , rmax , 10^(-5));

            if (r-r_num)/r > 10^(-3)
                error('the analytic root does not correspond to the radial streaming root')
            end  
            
            r_collection(k) = r;
        end
        r = best_line(r_collection,r_init,xmuestart);
        if isempty(r)
            xnew = xstart;
            last_scatter = 1;
        else
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
                last_scatter = 1;
            end  
        end
        
end
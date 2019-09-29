function [xnew,r,nin,last_scatter,xmueou] =  make_scattering_multiple_lines(xstart,xmuestart,...
    beta,alpha,b,rmax,xk0,nin,...
    resonance_x,r_init,all_radial,isotropic_scattering)

        last_scatter = 0;

        pstart = sqrt(1-xmuestart^2);
        
        r_collection = zeros(1,length(resonance_x));
        for k = 1:length(resonance_x)
            if sign(xmuestart) == 1
                r_anal = b/(1-(xstart-resonance_x(k))^(1/beta));
                r = max(1,min(r_anal,rmax));
            else
                r_anal = b/(1-(-xstart+resonance_x(k))^(1/beta));
                r = max(1,min(r_anal,rmax));
            end

            func = @(r) sqrt(1-(pstart/r)^2)*(1-b/r)^beta - xstart - resonance_x(k);
            r_num = rtbis(func , 1 , rmax , 10^(-6));

            if ((r-r_num)/r > 10^(-3)) 
                error('the analytic root does not correspond to the radial streaming root')
            end  
            r_collection(k) = r;
        end
%         display(xstart)
%         display(resonance_x)
%         display(r_collection)
        r = best_line(r_collection,r_init,xmuestart);
        
        if isempty(r)
            xnew = xstart;
            last_scatter = 1;
            xmueou = xmuestart;
        else
            xmuein = sqrt(1-(pstart/r)^2);
            v = (1-b/r)^(beta);
            dvdr = b*beta/r^2*(1-b/r)^(beta-1);
            sigma = dvdr/(v/r)-1;
            tau = xk0/(r*v^(2-alpha)*(1+xmuein^2*sigma));

            if tau >= rand
                xmueou = xmueout(xk0,alpha,r,v,sigma,all_radial);
                if isotropic_scattering == 1
                    xmueou = 2*rand-1;
                end

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
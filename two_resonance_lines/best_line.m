function [r,x_selected,tau_selected] = best_line(xmuestart,xstart,resonance_x,resonance_tau,r_init,rmax,b,beta,nsc)
        % determine radius of interaction

        pstart = sqrt(1-xmuestart^2);
        r_collection = zeros(1,length(resonance_x));
        for k = 1:length(resonance_x)
            r_anal = b/(1-(-xstart + resonance_x(k))^(1/beta));
            r_anal = min(r_anal,rmax);

            func = @(r) sqrt(1-(pstart/r)^2)*(1-b/r)^beta - (-xstart + resonance_x(k));
            func = @(r) xmuestart*(1-b/r)^beta - (-xstart + resonance_x(k));
            r_num = rtbis(func , 1 , rmax , 10^(-7));

            if ((r_anal-r_num) > 10^(-2)) & (xmuestart == 1)
                display('____________')
                display(r_anal)
                display(r_num)
                display(xstart)
                error('the analytic root does not correspond to the radial streaming root')
            end  
            r_collection(k) = r_num;
        end
        
        if length(r_collection) == 1
            r = r_collection;
            x_selected = resonance_x;
            tau_selected = resonance_tau;
        else
            if nsc == 0
%                 display('first scattering')
                [r,index] = min(r_collection);
                x_selected = resonance_x(index);
                tau_selected = resonance_tau(index);
            else
                r = min(r_collection(sign(xmuestart)*(r_collection-r_init)>0));
%                 display('multiple scatterings')
%                 display(r_init)
%                 display(r_collection)
%                 display(xmuestart)
%                 display(r);    
                if length(r) > 0
                    index = find(r_collection == r);
                    index = index(1);
                    x_selected = resonance_x(index);
                    tau_selected = resonance_tau(index);
                else
                    x_selected = [];
                    tau_selected = [];
                end
            end
        end
end
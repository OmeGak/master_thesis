function [r,x_selected,tau_selected,last_scatter,index]...
    = best_line(xmuestart,xstart,resonance_x,resonance_tau,r_init,rmax,b,beta,vmin,vmax)
        % determine radius of interaction
        
        last_scatter = 0;
        Lucy_Abbott = 0;
        make_display = 0;
        
        
        % FIRST METHOD - (by default)
        pstart = sqrt(1-xmuestart^2);
        r_collection = [];
        index = 0;
        
        for k = 1:length(resonance_x)
            % numerical root
            func = @(r) sqrt(1-(pstart./r).^2).*(1-b./r).^beta - (-xstart + resonance_x(k));
            
            if make_display == 1
                display('__________________')
                display(xmuestart)
                display(xstart)
                display(pstart)
                display(b)
                display('resonance_x(k) = '), display(resonance_x(k))
                display(rmax)           
                iets = xmuestart*(1-b/1.32707417) + (-xstart + resonance_x(k));
                display(iets)  
                display('func(b) = '), display(func(b))
            end
            
            [r_num,no_solution] = rtbis(func , 1 , rmax +1, 10^(-5));

            % analytical root
            r_anal = b/(1-(-xstart + resonance_x(k))^(1/beta));
            r_anal = min(r_anal,rmax);
            
            if ((r_anal-r_num) > 10^(-2)) & (xmuestart == 1)
                error('the analytic root does not correspond to the radial streaming root')
            end  
            
            if no_solution == 0
                r_collection = [r_collection, r_num; resonance_x(k)];
            end
        end
        
        if length(r_collection) == 1
            r = r_collection;
            x_selected = resonance_x;
            tau_selected = resonance_tau;
        else
            r_collection_r = r_collection(1,:);
            r = min(r_collection_r(sign(xmuestart)*(r_collection_r-r_init)>0));

            if length(r) > 0
                index = max(find(r_collection == r));
                x_selected = r_collection(2,index);
                tau_selected = resonance_tau(index);
            else
                x_selected = [];
                tau_selected = [];
                last_scatter = 1;
            end
        end
        
                
        if Lucy_Abbott == 1
            % OTHER METHOD: TAKE LOWEST FREQUENCY!
                % see [Lucy & Abbott]

           pos_resonance_x = resonance_x-xstart;
           pos_resonance_x = pos_resonance_x(pos_resonance_x > 0);
           [x_selected,index] = min(pos_resonance_x);
           x_selected = x_selected + xstart;
           tau_selected = resonance_tau(index);

           vmin_ = 0.99*vmin;
           vmax_ = 1.01*vmax;

           if ((xstart - x_selected) < vmin_) | ((xstart - x_selected) > vmax_)
               tau_selected = [];
    %            display('this thing is corrupted')
    %            display(vmin_),display(vmax_)
               display(xstart)
               r = [];
               last_scatter = 1;
           else
               pstart = sqrt(1-xmuestart^2);
               func = @(r) sqrt(1-(pstart./r).^2).*(1-b./r).^beta - (-xstart + x_selected);          
               r = rtbis(func , 1 , rmax +1, 10^(-5));
           end
        end
            
end
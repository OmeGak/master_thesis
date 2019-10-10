function [r,x_selected,tau_selected,last_scatter]...
    = best_line(xmuestart,xstart,resonance_x,resonance_tau,r_init,rmax,b,beta,nsc,vmin,vmax)
        % determine radius of interaction
        
        last_scatter = 0;

%         pstart = sqrt(1-xmuestart^2);
%         r_collection = zeros(1,length(resonance_x));
%         for k = 1:length(resonance_x)
% 
%             func = @(r) sqrt(1-(pstart./r).^2).*(1-b./r).^beta - (-xstart + resonance_x(k));
%             
%             display('__________________')
%             display(xmuestart)
%             display(xstart)
%             display(pstart)
%             display(b)
%             display('resonance_x(k) = '), display(resonance_x(k))
%             display(rmax)           
%             iets = xmuestart*(1-b/1.32707417) + (-xstart + resonance_x(k));
%             display(iets)  
%             display('func(b) = '), display(func(b))
%             
%             r_num = rtbis(func , 1 , rmax +1, 10^(-5));
% 
%             r_anal = b/(1-(-xstart + resonance_x(k))^(1/beta));
%             r_anal = min(r_anal,rmax);
%             
%             if ((r_anal-r_num) > 10^(-2)) & (xmuestart == 1)
%                 display('____________')
%                 display(r_anal)
%                 display(r_num)
%                 display(xstart)
%                 error('the analytic root does not correspond to the radial streaming root')
%             end  
%             r_collection(k) = r_num;
%         end
%         
%         if length(r_collection) == 1
%             r = r_collection;
%             x_selected = resonance_x;
%             tau_selected = resonance_tau;
%         else
%             if nsc == 0
% %                 display('first scattering')
%                 [r,index] = min(r_collection);
%                 x_selected = resonance_x(index);
%                 tau_selected = resonance_tau(index);
%             else
%                 r = min(r_collection(sign(xmuestart)*(r_collection-r_init)>0));
% 
%                 if length(r) > 0
%                     index = find(r_collection == r);
%                     index = index(1);
%                     x_selected = resonance_x(index);
%                     tau_selected = resonance_tau(index);
%                 else
%                     x_selected = [];
%                     tau_selected = [];
%                 end
%             end
%         end
        
        
        % OTHER METHOD: TAKE LOWEST FREQUENCY!
            % see [Lucy & Abbott]
%        display(xstart)
%        display(resonance_x)
       
       pos_resonance_x = resonance_x-xstart;
       pos_resonance_x = pos_resonance_x(pos_resonance_x > 0);
       [x_selected,index] = min(pos_resonance_x);
       x_selected = x_selected + xstart;
       tau_selected = resonance_tau(index);
       
%        display(x_selected)
%        display(tau_selected)
%        display('xstart - x_selected = '),display(xstart - x_selected)
       
       % test if resonance is possible with the new frequency
%        vmin_ = x_selected + 0.99*vmin;
%        vmax_ = x_selected + 1.01*vmax;
       vmin_ = 0.99*vmin;
       vmax_ = 1.01*vmax;
%        display(vmin_)
%        display(vmax_)

%         display(b)
%         display(rmax)
      
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
           
%            if xstart_Fortran == 1
%                func = @(r) sqrt(1-(pstart./r).^2).*(1-b./r).^beta + (-xstart + x_selected);
%            end
           
           r = rtbis(func , 1 , rmax +1, 10^(-5));
       end
            
end
function [xnew,rnew,nin,last_scatter,xmueou,nsc,one_photon_path,forget_photon,luminosity,nsc_real] ...
            =  make_scattering(xstart,xmuestart,r_init,...
                beta,alpha,b,rmax,nin,resonance_x,resonance_tau,all_radial,isotropic_scattering,nsc,...
                one_photon_path,vmin,vmax,xstart_Fortran,luminosity,nrbins,nsc_real)
    
    % initialize parameters        
    forget_photon = 0;
    if xstart_Fortran == 1
        xstart = -xstart;
    end

    last_scatter = 0;
    
    % look for best radius of interaction
    pstart = sqrt(1-(xmuestart)^2);      % ADAPTATION ATTENTION
    r_collection = [];
    index = 0;

    for k = 1:length(resonance_x)
        % numerical root
        func = @(r) sqrt(1-(pstart./r).^2).*(1-b./r).^beta - (-xstart + resonance_x(k));           
        [r_num,no_solution] = rtbis(func , 1 , rmax, 10^(-5));

        if no_solution == 0
            r_collection_add = [r_num ; resonance_x(k); resonance_tau(k)];
            r_collection = [r_collection, r_collection_add];
        end
    end
    if length(r_collection) == 0
        last_scatter = 1;
    else
        r_collection_r = r_collection(1,:);
        rnew = min(r_collection_r(sign(xmuestart)*(r_collection_r-r_init)>0));

        if length(rnew) > 0
            index = max(find(r_collection_r == rnew));
            x_selected = r_collection(2,index);
            tau_selected = r_collection(3,index);

            % extra test
            vmin_ = x_selected + 0.99*vmin;
            vmax_ = x_selected + 1.01*vmax;
            if (xstart < vmin_) | (xstart > vmax_)
                last_scatter = 1;
            end

        else
            x_selected = [];
            tau_selected = [];
            last_scatter = 1;
        end
    end
    
    
    % make scattering event
    if last_scatter == 0
        xstart = xstart - x_selected;
        
        % perform scattering !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
        forget_photon = 0;
        xk0 = tau_selected;

        pstart = sqrt(1-(xmuestart/r_init)^2);          % ADAPTION ATTENTION
        xmuein = sqrt(1-(r_init*pstart/rnew)^2);        % ADAPTION ATTENTION
        v = (1-b/rnew)^(beta);
        dvdr = b*beta/rnew^2*(1-b/rnew)^(beta-1);
        sigma = dvdr/(v/rnew)-1;
        tau = xk0/(rnew*v^(2-alpha)*(1+xmuein^2*sigma));

        if tau > -log(rand)
            nsc_real = nsc_real + 1;
            
            xmueou = xmueout(xk0,alpha,rnew,v,sigma,all_radial);
            if isotropic_scattering == 1
                xmueou = 2*rand-1;
            end
            
            if rand >= 0.5
                xmueou = -xmueou;
                if sqrt(rnew^2*(1-xmueou^2)) <= 1
                    nin = nin +1;
                    forget_photon = 1;
                end
            end
        else        
            xmueou = xmuein;
%             rnew = r_init;
        end
        xnew = xstart - v*(xmueou-xmuein);
        % voila !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
        
        nsc = nsc + 1;
                
        if xstart_Fortran == 1
            xnew = -xnew;
        end
        
        xnew = xnew + x_selected;
        
        if (xnew == xstart)
%             display('xnew = xstart ----------')
%             display(r_init)
%             display(rnew)
%             error('xnew = xstart -- make_scattering.m')
        end
        
        if (xnew < -0.5) & (xmueou < 0)
            display('----------')
            display(r_init)
            display(rnew)
            display('het is zover -- make_scattering.m')
        end
          
        %luminosity = update_luminosity_scatter(xmuestart,rnew,luminosity,r_init,rmax,nrbins);
        one_photon_path = [one_photon_path; rnew; xmueou; xnew; x_selected];    
        
    else
        xnew = xstart;
        xmueou = xmuestart;
%         rnew = r_init;
    end      
    
end
function [xnew,rnew,nin,last_scatter,xmueou,nsc,one_photon_path,forget_photon,luminosity,nsc_real,tau_decides_no_scatter_x] ...
            =  make_scattering(xstart,xmuestart,r_init,...
                beta,alpha,b,rmax,nin,resonance_x,resonance_tau,all_radial,isotropic_scattering,nsc,...
                one_photon_path,vmin,vmax,xstart_Fortran,luminosity,nrbins,nsc_real,tau_decides_no_scatter_x,phot,only_positive_xmueou)
    
    % initialize parameters        
    forget_photon = 0;
    if xstart_Fortran == 1
        xstart = -xstart;
    end

    last_scatter = 1;
    
    % look for best radius of interaction !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
    pstart = r_init*sqrt(1-(xmuestart)^2);      
    r_collection = [];
    index = 0;

    for k = 1:length(resonance_x)
        x_selected = resonance_x(k);
        
        vmin_ = x_selected + 0.99*vmin;
        vmax_ = x_selected + 1.01*vmax;
        if (xstart >= vmin_) & (xstart <= vmax_) & (abs(x_selected - tau_decides_no_scatter_x) > 0)
            
            % numerical root
            func = @(r) sqrt(1-(pstart./r).^2).*(1-b./r).^beta - (-xstart + x_selected);         % ADAPTATION ATTENTION      
            [r_num,no_solution] = rtbis(func , 1 , rmax, 10^(-5));

            if no_solution == 0
                r_collection_add = [r_num ; x_selected; resonance_tau(k)];
                r_collection = [r_collection, r_collection_add];
            end    
        else
            rnew = r_init;
        end
    end
    
    if isempty(r_collection) == 0
        r_collection_r = r_collection(1,:);
        rnew = min(r_collection_r(sign(xmuestart)*(r_collection_r-r_init)>0));

        if isempty(rnew) == 0
            index = find(r_collection_r == rnew);
            x_selected = r_collection(2,index);
            tau_selected = r_collection(3,index);
            last_scatter = 0;
        end
    end
    
    if phot == 1
        display(r_collection)
    end
    
    % we have the radius of interaction !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
    tau_decides_no_scatter_x = x_selected;
    
    % perform scattering !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
    if last_scatter == 0
        xstart = xstart - x_selected;
           
        forget_photon = 0;
        xk0 = tau_selected;
 
        xmuein = sqrt(1-(pstart/rnew)^2);                           
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
            
            if only_positive_xmueou == 0
                if rand >= 0.5
                    xmueou = -xmueou;
                    if sqrt(rnew^2*(1-xmueou^2)) <= 1
                        nin = nin +1;
                        forget_photon = 1;                                     % mind L(r)
                    end
                end
            end
            
        else
            tau_decides_no_scatter_x = x_selected;
            xmueou = xmuein;
        end
        xnew = xstart - v*(xmueou-xmuein);                
        if xstart_Fortran == 1
            xnew = -xnew;
        end
        xnew = xnew + x_selected;
        nsc = nsc + 1;
        % voila !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!! 
          
        luminosity = update_luminosity_scatter(xmuestart,rnew,luminosity,r_init,rmax,nrbins,forget_photon);
        one_photon_path = [one_photon_path; rnew; xmueou; xnew; x_selected];    
        
    else
        xnew = xstart;
        xmueou = xmuestart;
        % UPDATE R?
    end      
    
end
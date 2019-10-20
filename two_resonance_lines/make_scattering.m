function [xnew,rnew,nin,last_scatter,xmueou,nsc,one_photon_path,forget_photon,luminosity,nsc_real,scattering_x,tau_decides_no_scatter_x] ...
            =  make_scattering(xstart,xmuestart,r_init,...
                beta,alpha,b,rmax,nin,resonance_x,resonance_tau,all_radial,isotropic_scattering,nsc,...
                one_photon_path,vmin,vmax,xstart_Fortran,luminosity,nrbins,nsc_real,scattering_x,tau_decides_no_scatter_x,phot)
    
    % initialize parameters        
    forget_photon = 0;
    if xstart_Fortran == 1
        xstart = -xstart;
    end

    rnew = r_init; 
    last_scatter = 1;
    
    % look for best radius of interaction !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
    pstart = sqrt(1-(xmuestart)^2);      
    r_collection = [];
    index = 0;

    for k = 1:length(resonance_x)
        x_selected = resonance_x(k);
        
        vmin_ = x_selected + 0.99*vmin;
        vmax_ = x_selected + 1.01*vmax;
        if (xstart >= vmin_) & (xstart <= vmax_) %& (abs(x_selected - tau_decides_no_scatter_x) > 0)
            
            % numerical root
            func = @(r) sqrt(1-(r_init*pstart./r).^2).*(1-b./r).^beta - (-xstart + x_selected);         % ADAPTATION ATTENTION      
            [r_num,no_solution] = rtbis(func , 1 , rmax, 10^(-5));

            if no_solution == 0
                r_collection_add = [r_num ; x_selected; resonance_tau(k)];
                r_collection = [r_collection, r_collection_add];
            end            
        end
    end
    
    if length(r_collection) > 0
        r_collection_r = r_collection(1,:);
        rnew = min(r_collection_r(sign(xmuestart)*(r_collection_r-r_init)>0));

        if length(rnew) > 0
            index = find(r_collection_r == rnew);
            x_selected = r_collection(2,index);
            tau_selected = r_collection(3,index);
            last_scatter = 0;
        end
    end
    
    if last_scatter == 0
        scattering_x = [scattering_x, x_selected];
    end
    % we have the radius of interaction !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
    tau_decides_no_scatter_x = x_selected;
    
    % perform scattering !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
    if last_scatter == 0
        xstart = xstart - x_selected;
           
        forget_photon = 0;
        xk0 = tau_selected;

        pstart = sqrt(1-(xmuestart)^2);            
        xmuein = sqrt(1-(r_init*pstart/rnew)^2);                           % ADAPTION ATTENTION
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
            tau_decides_no_scatter_x = x_selected;
            xmueou = xmuein;
            display('xnew = xstart ----------')
        end
        xnew = xstart - v*(xmueou-xmuein);
        % voila !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!     
        nsc = nsc + 1;
                
        if xstart_Fortran == 1
            xnew = -xnew;
        end
        
        xnew = xnew + x_selected;
        
        if (xnew == xstart)
            display('xnew = xstart ----------')
        end
          
        luminosity = update_luminosity_scatter(xmuestart,rnew,luminosity,r_init,rmax,nrbins);
        one_photon_path = [one_photon_path; rnew; xmueou; xnew; x_selected];    
        
    else
        xnew = xstart;
        xmueou = xmuestart;
        % UPDATE R?
    end      
    
end
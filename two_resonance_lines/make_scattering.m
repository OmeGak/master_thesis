function [xnew,r,nin,last_scatter,xmueou,nsc,one_photon_path,forget_photon,...
        x_selected,luminosity] ...
            =  make_scattering(xstart,xmuestart,r_init,...
                beta,alpha,b,rmax,nin,resonance_x,resonance_tau,all_radial,isotropic_scattering,nsc,...
                one_photon_path,vmin,vmax,xstart_Fortran,luminosity,nrbins)
    
    % initialize parameters        
    forget_photon = 0;
    if xstart_Fortran == 1
        xstart = -xstart;
    end

    % look for best radius of interaction
    [r,x_selected,tau_selected,last_scatter] ...
        = best_line(xmuestart,xstart,resonance_x,resonance_tau,r_init,rmax,b,beta,vmin,vmax);
    
    % make scattering event
    if last_scatter == 0
        xstart = xstart - x_selected;
        
        [xnew,xmueou,forget_photon,nin] ...
            = scatter(xstart,tau_selected,xmuestart,r,b,beta,alpha,all_radial,nsc,isotropic_scattering,nin);
        nsc = nsc + 1;
                
        if xstart_Fortran == 1
            xnew = -xnew;
        end
        
        xnew = xnew + x_selected;
        
        if (xnew < -0.5) & (xmueou < 0)
            error('het is zover')
        end
          
        luminosity = update_luminosity_scatter(xmuestart,r,luminosity,r_init,rmax,nrbins);
        one_photon_path = [one_photon_path; r; xmueou; xnew; x_selected];    
        
    else
        xnew = xstart;
        xmueou = xmuestart;
    end      
    
end
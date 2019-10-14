function [xnew,r,nin,last_scatter,xmueou,nsc,photon_path,forget_photon,...
        x_selected,luminosity] ...
            =  make_scattering(xstart,xmuestart,r_init,...
                beta,alpha,b,rmax,nin,resonance_x,resonance_tau,all_radial,isotropic_scattering,nsc,...
                photon_path,vmin,vmax,xstart_Fortran,luminosity,nrbins)
            
    forget_photon = 0;
    
    if xstart_Fortran == 1
        xstart = -xstart;
    end

    [r,x_selected,tau_selected,last_scatter,index] ...
        = best_line(xmuestart,xstart,resonance_x,resonance_tau,r_init,rmax,b,beta,vmin,vmax);
    
    if last_scatter == 0
        xstart = xstart - x_selected;
        
        [xnew,xmueou,last_scatter,forget_photon,nin] ...
            = scatter(xstart,tau_selected,xmuestart,r,b,beta,alpha,all_radial,nsc,isotropic_scattering,nin);
        nsc = nsc + 1;
        
        if xstart_Fortran == 1
            xnew = -xnew;
        end
        
        xnew = xnew + x_selected;
          
        % update luminosity
        dr = (rmax-1)/nrbins;
        rmin = 1;
        
        if sign(xmuestart) == 1
            r_index_min = floor((r_init-rmin)/dr) + 1;
            r_index_max = floor((r-rmin)/dr) + 1;
        else
            r_index_min = floor((r-rmin)/dr) + 1;
            r_index_max = floor((r_init-rmin)/dr) + 1;
        end
        
%         display(r_init)
%         display(r)
%         display(r_index_min)
%         display(r_index_max)
        luminosity(r_index_min : r_index_max) = luminosity(r_index_min : r_index_max) + sign(xmuestart); 
        
    else
        xnew = xstart;
        last_scatter = 1;
        xmueou = xmuestart;
    end   

    if length(resonance_x) == 1
        last_scatter = 1;
    end    
    
end
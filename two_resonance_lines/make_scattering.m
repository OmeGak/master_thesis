function [xnew,r,nin,last_scatter,xmueou,nsc,photon_path,forget_photon,yes] =  make_scattering(xstart,xmuestart,r_init,...
        beta,alpha,b,rmax,nin,resonance_x,resonance_tau,all_radial,isotropic_scattering,nsc,...
        photon_path,phot,last_scatter,vmin,vmax,xstart_Fortran,yes)

    forget_photon = 0;
%         display(xstart)
%         display(last_scatter)
    
    if xstart_Fortran == 1
        xstart = -xstart;
    end

    [r,x_selected,tau_selected,last_scatter] ...
        = best_line(xmuestart,xstart,resonance_x,resonance_tau,r_init,rmax,b,beta,nsc,vmin,vmax,xstart_Fortran);
    if length(r) > 0
        yes(3,phot) = r;
    end
        
    if last_scatter == 0
        [xnew,xmueou,last_scatter,forget_photon] ...
            = scatter(xstart,x_selected,tau_selected,xmuestart,r,b,beta,alpha,all_radial,nsc,isotropic_scattering,nin);
        nsc = nsc + 1;
    else
        xnew = xstart;
        last_scatter = 1;
        xmueou = xmuestart;
    end   

    if length(resonance_x) == 1
        last_scatter = 1;
    end
    
%     if xstart_Fortran == 1
%         xnew = -xnew;
%     end
    
end
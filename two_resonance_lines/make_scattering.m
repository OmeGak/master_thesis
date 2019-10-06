function [xnew,r,nin,last_scatter,xmueou,nsc,photon_path] =  make_scattering(xstart,xmuestart,...
        beta,alpha,b,rmax,xk0,nin,resonance_x,resonance_tau,r_init,all_radial,isotropic_scattering,nsc,...
        photon_path,phot,last_scatter)

        [r,x_selected,tau_selected] = best_line(xmuestart,xstart,resonance_x,resonance_tau,r_init,rmax,b,beta);
        if (xstart-x_selected) < -0.8
            error('HELP')
        end
        
        if length(r) > 0
            [xnew,xmueou] = scatter(xstart,x_selected,tau_selected,xmuestart,r,b,xk0,beta,alpha,all_radial,nsc,isotropic_scattering,nin);
            nsc = nsc + 1;
        else
            xnew = xstart;
            last_scatter = 1;
            xmueou = xmuestart;
        end      
end
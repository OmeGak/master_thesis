function [xnew,r,nin,last_scatter,xmueou,nsc,photon_path] =  make_scattering(xstart,xmuestart,...
        beta,alpha,b,rmax,xk0,nin,resonance_x,r_init,all_radial,isotropic_scattering,nsc,...
        photon_path,phot,last_scatter)

        [r,x_selected] = best_line(xmuestart,xstart,resonance_x,r_init,rmax,b,beta);
        if (xstart-x_selected) < -0.8
            error('HELP')
        end
        
        if length(r) > 0
            [xnew,xmueou] = scatter(xstart,x_selected,xmuestart,r,b,xk0,beta,alpha,all_radial,nsc,isotropic_scattering,nin);
        else
            xnew = xstart;
            last_scatter = 1;
            xmueou = xmuestart;
        end      

        photon_path(2*nsc+1,phot) = r;
        photon_path(2*nsc+2,phot) = xmueou;
end
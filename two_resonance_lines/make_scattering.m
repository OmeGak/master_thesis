function [xnew,r,nin,last_scatter,xmueou,nsc,photon_path] =  make_scattering(xstart,xmuestart,...
        beta,alpha,b,rmax,xk0,nin,resonance_x,r_init,all_radial,isotropic_scattering,nsc,photon_path,phot,case_number)

        last_scatter = 0;

        r = best_line(xmuestart,xstart,resonance_x,r_init,rmax,b,beta);
        
        if length(r) > 0
            [xnew,xmueou] = scatter(xstart,xmuestart,r,b,xk0,beta,alpha,all_radial,nsc,isotropic_scattering,nin,case_number);
        else
            display('dat spel is hier leeg')
            xnew = xstart;
            last_scatter = 1;
            xmueou = xmuestart;
        end      

        photon_path(3,phot) = r;
        photon_path(4,phot) = xmueou;
end
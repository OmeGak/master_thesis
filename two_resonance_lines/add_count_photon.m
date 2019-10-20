function [nout,flux] = add_count_photon(xnew,xstart,nout,xmin,deltax,nchan,flux,r,plot_only_scattering,forget_photon,goto_end_of_loop)
    if (plot_only_scattering == 0) & (forget_photon == 0)
            % tally the photons
            nout = nout + 1;
            ichan = floor((xnew-xmin)/deltax) + 1;
            flux(ichan) = flux(ichan) +1;  

            if (ichan < 1) | (ichan > nchan)
                error('oei oei');
            end     
    end
    if plot_only_scattering == 1
        if goto_end_of_loop == 0
            % tally the photons
            nout = nout + 1;
            ichan = floor((xnew-xmin)/deltax) + 1;
            flux(ichan) = flux(ichan) +1;  

            if (ichan < 1) | (ichan > nchan)
                error('oei oei');
            end     
        end
    end
end
function [nout,flux] = add_count_photon(xnew,nout,xmin,deltax,nchan,flux)
        % tally the photons
        nout = nout + 1;
        ichan = floor((xnew-xmin)/deltax) + 1;  
        if (ichan < 1) | (ichan > nchan)
            display('oei oei');
            display(xnew);
            ichan = 2;
        end
        flux(ichan) = flux(ichan) +1;  
end
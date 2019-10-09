function [nout,flux] = add_count_photon(xnew,xstart,nout,xmin,deltax,nchan,flux,r)
        % tally the photons
        nout = nout + 1;
        ichan = floor((xnew-xmin)/deltax) + 1;
        flux(ichan) = flux(ichan) +1;  
        
        if (ichan < 1) | (ichan > nchan)
            error('oei oei');
            display(xstart);
            display(xnew);
            display(r);
            ichan = 2;
        end       
end
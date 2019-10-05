function [xmuestart,photon_path] = release_photon(photon_path,radial_release,Eddington,phot)
        if radial_release == 1
            xmuestart = 1;
        elseif Eddington == 1
            xmuestart = Eddington()
        else
            xmuestart = sqrt(rand);
        end
        photon_path(2,phot) = xmuestart;
end
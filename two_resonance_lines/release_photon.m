function [xmuestart,one_photon_path] = release_photon(xstart,radial_release,Eddington)
        if radial_release == 1
            xmuestart = 1;
        elseif Eddington == 1
            xmuestart = Eddington()
        else
            xmuestart = sqrt(rand);
        end
        one_photon_path = [xstart ; xmuestart];
end
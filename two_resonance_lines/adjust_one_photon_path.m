function [photon_path,scattering_x] = adjust_one_photon_path(photon_path,one_photon_path,scattering_x,phot)

        % ADJUST PHOTON_PATH
        if length(one_photon_path) < size(photon_path,1)
            one_photon_path = [one_photon_path; nan*ones(size(photon_path,1) - length(one_photon_path),1)];
        elseif length(one_photon_path) > size(photon_path,1)
            photon_path = [photon_path; nan*ones(length(one_photon_path) - size(photon_path,1) , size(photon_path,2))];
        end
        photon_path = [photon_path, one_photon_path]; 
        
        one_scattering_x = [];
        K = (length(one_photon_path)-3)/4;
        for k=1:K
            one_scattering_x = [one_scattering_x; one_photon_path(2+k*4)];
        end
        
        % CREATE SCATTERING_X
        if length(one_scattering_x) < size(scattering_x,1)
            one_scattering_x = [one_scattering_x; nan*ones(size(scattering_x,1) - length(one_scattering_x),1)];
        elseif length(one_scattering_x) > size(scattering_x,1)
            scattering_x = [scattering_x; nan*ones(length(one_scattering_x) - size(scattering_x,1) , size(scattering_x,2))];
        end
        if (phot == 1) & (length(one_scattering_x) == 0)
            scattering_x = [nan;nan];
        end
            
        scattering_x = [scattering_x, one_scattering_x]; 
        
end
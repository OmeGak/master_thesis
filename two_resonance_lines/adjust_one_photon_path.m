function [photon_path] = adjust_one_photon_path(photon_path,one_photon_path)


        if length(one_photon_path) < size(photon_path,1)
            one_photon_path = [one_photon_path; zeros(size(photon_path,1) - length(one_photon_path),1)];
        elseif length(one_photon_path) > size(photon_path,1)
            photon_path = [photon_path; zeros(length(one_photon_path) - size(photon_path,1),size(photon_path,2))];
        end
        photon_path = [photon_path, one_photon_path]; 
        
end
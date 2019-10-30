function [luminosity,luminosity_min] = update_luminosity_scatter(xmuestart,rnew,luminosity,r_init,rmax,nrbins,forget_photon,phot,luminosity_min)
    % photon flying from r_init to rnew
    
if phot == 98
        dr = (rmax-1)/nrbins;
        rmin = 1;
        
        if (sign(xmuestart) == 1) | (sign(xmuestart) == 0)
            display('positive_contribution')
            r_index_min = floor((r_init-rmin)/dr) + 1;
            r_index_max = floor((rnew-rmin)/dr) + 1;
            if rnew >= rmax - dr
                r_index_max = nrbins ;
            end
            luminosity(r_index_min : r_index_max) = luminosity(r_index_min : r_index_max) + 1; 
            
        elseif (sign(xmuestart) == -1)  & (forget_photon == 1)
            display('scatter into core (luminosity_min)')
            r_index_min = floor((rnew-rmin)/dr) + 1;
            r_index_max = floor((r_init-rmin)/dr) + 1;
            if r_init >= rmax - dr
                r_index_max = nrbins ;
            end
            luminosity_min(r_index_min : r_index_max) = luminosity_min(r_index_min : r_index_max) +1;  
        else
            display('negative_contribution (luminosity_min))')
            r_index_min = floor((rnew-rmin)/dr) + 1;
            r_index_max = floor((r_init-rmin)/dr) + 1;
            luminosity_min(r_index_min : r_index_max) = luminosity_min(r_index_min : r_index_max) + 1; 
        end
        
           
end
end
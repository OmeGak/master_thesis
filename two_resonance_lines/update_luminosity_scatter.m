function luminosity = update_luminosity_scatter(xmuestart,r,luminosity,r_init,rmax,nrbins,forget_photon)
        dr = (rmax-1)/nrbins;
        rmin = 1;
        
        if sign(xmuestart) == 1
            r_index_min = floor((r_init-rmin)/dr) + 1;
            r_index_max = floor((r-rmin)/dr) + 1;
            if r >= rmax - dr
                r_index_max = nrbins ;
            end
        elseif (sign(xmuestart) == -1)  & (forget_photon == 1)
            r_index_min = floor((r-rmin)/dr) + 1;
            r_index_max = floor((r_init-rmin)/dr) + 1;
            if r_init >= rmax - dr
                r_index_max = nrbins ;
            end
        else
            r_index_min = floor((r-rmin)/dr) + 1;
            r_index_max = floor((r_init-rmin)/dr) + 1;
        end
        
        luminosity(r_index_min : r_index_max) = luminosity(r_index_min : r_index_max) + sign(xmuestart); 
end
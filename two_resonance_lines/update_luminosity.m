function luminosity = update_luminosity(xmuestart,r_new,rmax,rmin,nrbins,luminosity);

        % update luminosity
        dr = (rmax-rmin)/nrbins;
        if sign(xmuestart) == 1
            if r_new > 1
                r_index_min = floor((r_new-rmin)/dr) + 2;
                r_index_max = floor((rmax-rmin)/dr);
            else
                r_index_min = floor((r_new-rmin)/dr) + 1;
                r_index_max = floor((rmax-rmin)/dr);
            end
        else
            display('luminosity: sounds not good')
            r_index_max = floor((1-rmin)/dr) + 1;
            r_index_min = floor((r_new-rmin)/dr) ;
        end     
        luminosity(r_index_min : r_index_max) = luminosity(r_index_min : r_index_max) + sign(xmuestart); 
        
end
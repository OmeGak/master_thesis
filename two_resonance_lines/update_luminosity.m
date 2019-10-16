function [luminosity,count_neg_phot] = update_luminosity(xmuestart,r_new,rmax,rmin,nrbins,luminosity,count_neg_phot);
        dr = (rmax-rmin)/nrbins;
        
        if sign(xmuestart) == 1
            if r_new > 1
                r_index_min = floor((r_new-rmin)/dr) + 2;
                r_index_max = floor((rmax-rmin)/dr);
            else
                r_index_min = floor((r_new-rmin)/dr) + 1;
                r_index_max = floor((rmax-rmin)/dr);
            end
            
        elseif sign(xmuestart) == -1
            r_index_min = 1;
            r_index_max = floor((r_new-rmin)/dr) + 1;
            count_neg_phot = count_neg_phot + 1;
            
        end     

%         luminosity(r_index_min : r_index_max) = luminosity(r_index_min : r_index_max) + sign(xmuestart); 
                
end
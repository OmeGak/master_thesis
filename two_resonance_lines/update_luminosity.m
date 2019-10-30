function [luminosity,count_neg_phot,luminosity_min] = update_luminosity(xmuestart,r_init,rmax,rmin,nrbins,luminosity,count_neg_phot , ...
    goto_end_of_loop , forget_photon , phot,luminosity_min);
    % update luminosity at final time
    
    if phot > 0
        dr = (rmax-rmin)/nrbins;
        
        if (goto_end_of_loop == 1) | (forget_photon == 1) 
            if (sign(xmuestart) == 1) | (sign(xmuestart) == 0)
                display('last scatter - positive - first case')
                r_index_min = 1;
                r_index_max = nrbins;
                luminosity(r_index_min : r_index_max) = luminosity(r_index_min : r_index_max) + 1; 
            elseif sign(xmuestart) == -1
                display('last scatter - negative - first case (luminosity_min) [THUS forget_photon == 1]')
                r_index_min = 1;
                r_index_max = floor((r_init-rmin)/dr) + 1;
                count_neg_phot = count_neg_phot + 1;
                luminosity_min(r_index_min : r_index_max) = luminosity_min(r_index_min : r_index_max) +1; 
            end             
        else
            if (sign(xmuestart) == 1) | (sign(xmuestart) == 0)
                display('last scatter - positive')
                r_index_min = floor((r_init-rmin)/dr) + 2;
                r_index_max = floor((rmax-rmin)/dr);
                luminosity(r_index_min : r_index_max) = luminosity(r_index_min : r_index_max) + 1; 
            else
                % determine new r_min 
                % then go from r_init to r_min and then
                % from r_min to r_max

                r_nearest_star = r_init*sqrt(1-xmuestart^2);
                if floor(abs(r_nearest_star-r_init)/dr) > 1
                    display('last scatter - negative - complex situation')
                    display(r_nearest_star)
                    display('     amount of bins with negative values')
                    display(abs(r_nearest_star-r_init)/dr)

                    % negative contritubtion
                    r_index_min = floor((r_nearest_star-rmin)/dr) + 1;
                    r_index_max = floor((r_init-rmin)/dr) +1;
                    if abs(r_nearest_star-r_init) > dr
                        luminosity_min(r_index_min : r_index_max) = luminosity_min(r_index_min : r_index_max) + 1; 
                    end

                    % positive contribution
                    if floor(abs(r_nearest_star-r_init)/dr) > 1
                        r_index_min = floor((r_nearest_star-rmin)/dr) + 1;
                    else
                        r_index_min = floor((r_init-rmin)/dr) + 1;
                    end
                    r_index_max = nrbins;
                    luminosity(r_index_min : r_index_max) = luminosity(r_index_min : r_index_max) + 1;     
                else
                    display('more simple situation')
                    r_index_min = floor((r_init-rmin)/dr) + 2;
                    r_index_max = nrbins;
                    luminosity(r_index_min : r_index_max) = luminosity(r_index_min : r_index_max) + 1;  
                end
            end   
        end
    end
                
end
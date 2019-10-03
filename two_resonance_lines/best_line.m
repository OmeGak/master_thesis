function [r] = best_line(xmuestart,xstart,resonance_x,r_init,rmax,b,beta)
        % determine radius of interaction

        pstart = sqrt(1-xmuestart^2);
        r_collection = zeros(1,length(resonance_x));
        for k = 1:length(resonance_x)
            r_anal = b/(1-(xstart + resonance_x(k))^(1/beta));
            r_anal = min(r_anal,rmax);

            func = @(r) sqrt(1-(pstart/r)^2)*(1-b/r)^beta - (xstart + resonance_x(k));
            r_num = rtbis(func , 1 , rmax , 10^(-7));

            if ((r_anal-r_num) > 10^(-2)) & (xmuestart == 1) % the analytical root is only valid when xstart == 1
                display(r_anal)
                display(r_num)
                display(xstart)
                error('the analytic root does not correspond to the radial streaming root')
            end  
%             display(r_anal)
%             display(r_num)
            r_collection(k) = r_num;
        end

        if length(r_collection) == 1
            r = r_collection;
        else
            if xmuestart >= 0
                r = min(lines(sign(r_collection - r_init) == sign(xmuestart)));
            else
                r = max(lines(sign(r_collection - r_init) == sign(xmuestart)));
            end
        end
end
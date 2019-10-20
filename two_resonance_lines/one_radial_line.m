function [freq,flux,yes] = one_radial_line(nphot , xk0 , alpha , beta , make_plot , save , all_radial , radial_release)
    % set random number generator
    rng(10);
%     s = rng;

    nchan = 100;

    xmax = 1.1;
    vmin = 0.01;

    deltax = 2*xmax/nchan;
    freq = zeros(1,nchan);
    flux = zeros(1,nchan);
    freq(1) = xmax-.5*deltax;
        
    for n=2:nchan
        freq(n) = freq(1)-(n-1)*deltax;
    end

    b = 1-vmin^(1/beta);
    vmax = 0.98;
    rmax = b/(1-vmax^(1/beta));

    nin = 0;
    nout = 0;

    yes = zeros(4,nphot);
    
    for phot = 1:nphot       
        goto_end_of_loop = 0;

        xstart = xmax*rand;

        xrnd = rand;
        if xrnd >= 0.5
            xstart = -xstart;
            xnew = xstart;
            goto_end_of_loop = 1;
        end

        if (goto_end_of_loop == 0)
            vmax1 = vmax*0.99;
            vmin1 = vmin*1.01;
            if (xstart >= vmax1) | (xstart <= vmin1)
                % no resonance possible
                xnew = xstart;
                goto_end_of_loop = 1;
            end
            yes(1,phot) = xstart;
        end
                
        forget_photon = 0;
        % here the scattering part begins
        if (goto_end_of_loop == 0)

            xmuestart = sqrt(rand);
            if radial_release == 1
                xmuestart = 1;
            end
            
            yes(2,phot) = xmuestart;
            
            pstart = sqrt(1-xmuestart^2);

            func = @(r) sqrt(1-(pstart/r)^2)*(1-b/r)^beta - xstart;
            r = rtbis(func , 1 , rmax , 10^(-5));            
            if xmuestart == 1
                r_anal = b/(1-xstart^(1/beta));
                r_anal = max(1,min(r_anal,rmax));
                if (abs(r_anal-r) > 10^(-2))
                    error('wat is me dat hier')
                end
            end
            
            yes(3,phot) = r;

            xmuein = sqrt(1-(pstart/r)^2);

            v = (1-b/r)^(beta);
            dvdr = b*beta/r^2*(1-b/r)^(beta-1);
            sigma = dvdr/(v/r)-1;
            tau = xk0/(r*v^(2-alpha)*(1+xmuein^2*sigma));

            if tau > -log(rand)
                xmueou = xmueout(xk0,alpha,r,v,sigma,all_radial);

                if rand >= 0.5
                    xmueou = -xmueou;
                    pcheck = sqrt(r^2*(1-xmueou^2));
                    if pcheck <= 1
                        nin = nin +1;
                        forget_photon = 1;
                    end
                end

                xnew = xstart + v*(xmueou-xmuein);

            else
                xnew = xstart;
                display('hallo there is no scattering')
            end    
        end

        yes(4,phot) = xnew;
        
        % tally the photons
        nout = nout + 1;
        
        if (forget_photon == 0)
            ichan = floor((xmax-xnew)/deltax)+1;
            flux(ichan) = flux(ichan) +1;
        end

    end

    xnorm = nphot/nchan;
    back_scattered_percent = nin/nphot*100;

    flux = flux/xnorm;

    % turn the frequency array around itself !!! !!! !!! !!! !!! !!! !!! 
    freq_ = freq;
    for k = 1:length(freq)
        freq(k) = freq_(end+1-k);
    end
    
    % make figure
    if make_plot == 1
        figure()
        plot(freq,flux)
        if save == 1
            saveas(gcf,'data/radial_one_line.png')
        end
    end
end
    
    
    
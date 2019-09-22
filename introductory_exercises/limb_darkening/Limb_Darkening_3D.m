function Limb_Darkening_3D(number_of_channels , number_of_photons , maximum_optical_depth)

    % number of channels
    na = number_of_channels;

    % number of photons
    nphot =  number_of_photons;
    
    % maximum optical depth
    taumax = maximum_optical_depth;

    muarray = zeros(na);
    phiarray = zeros(na);
    dmu = 1./na;
    dphi = 2*pi./na;

    % loop over all photons
    for l = 1:nphot
        tau = taumax;

        % follow the path of the photon through atmosphere,
        % it finally escapes under angle MU

        while (tau >= 0)
            % angle mu
            x = rand();
            % angle phi
            x3 = rand();
            
            % optical depth
            x2 = rand();

            if (tau >= taumax)
                mu = sqrt(x);
                tau = taumax;
            else
                mu = 2*x- 1; 
            end
            phi = 2*pi*x3;

            tau_i = -log(x2);
            tau = tau - tau_i*mu;
        end

        % collect the mu things
        k = 1;
        dummy = dmu;
        while ((mu - dummy) > 0)
            dummy = dmu*(k+1);
            k = k + 1;
        end
        i = k;
        muarray(i) = muarray(i) + 1;

        % idem for phi things
        k = 1;
        dummy = dphi;
        while ((phi - dummy) > 0)
            dummy = dphi*(k+1);
            k = k + 1;
        end
        j = k;
        phiarray(j) = phiarray(j) + 1;    
    
    end

    % simple test for one aspect of the correctness of the program
    isum = 0;
    for i=1:na
        isum = isum + muarray(i);
    end
    if ~(isum == nphot)
        display('er is een foton verloren');
    end

    % collect the data
    mudata = [];
    for i = 1:na
        mu = (i-0.5)*dmu;
        mudist =  muarray(i)/mu;
        mudata = [mudata; mu, mudist];
    end
    
    phidata = [];
    for i = 1:na
        phi = (i-0.5)*dphi;
        phidist =  phiarray(i);
        phidata = [phidata; phi, phidist];
    end

    % make plot
    figure(1)
    stairs(mudata(:,1),mudata(:,2)/mudata(end,2),'-')
    xlabel('angle')
    ylabel('photo-dist','Rotation',0)
    
    figure(2)
    stairs(phidata(:,1),phidata(:,2)/phidata(end,2),'-')
    xlabel('angle')
    ylabel('photo-dist','Rotation',0)
    xlim([0, 2*pi])
    set(gca,'XTick',0:pi:2*pi) 
    set(gca,'XTickLabel',{'0','\pi','2\pi'})
   
end
    
    

function total_interactions = Limb_Darkening(number_of_channels , number_of_photons , maximum_optical_depth)

    % number of channels
    na = number_of_channels;

    % number of photons
    nphot =  number_of_photons;
    
    % maximum optical depth
    taumax = maximum_optical_depth;

    muarray = zeros(na);
    dmu = 1./na;

    total_interactions = 0;
    % loop over all photons
    for l = 1:nphot
        tau = taumax;

        % follow the path of the photon through atmosphere,
        % it finally escapes under angle MU

        number_interactions = 0;
        while (tau >= 0)
            % angle
            x = rand();

            % optical depth
            x2 = rand();

            if (tau >= taumax)
                mu = sqrt(x);
                tau = taumax;
            else
                mu = 2*x- 1;
            end

            tau_i = -log(x2);
            tau = tau - tau_i*mu;
            
            number_interactions = number_interactions + 1;
        end

        k = 1;
        dummy = dmu;
        while ((mu - dummy) > 0)
            dummy = dmu*(k+1);
            k = k + 1;
        end

        i = k;
        muarray(i) = muarray(i) + 1;
        
        total_interactions = total_interactions + number_interactions;
    end
    total_interactions = total_interactions/nphot;
    
    % simple test for one aspect of the correctness of the program
    isum = 0;
    for i=1:na
        isum = isum + muarray(i);
    end
    if ~(isum == nphot)
        display('er is een foton verloren');
    end

    % collect the data
    data = [];
    for i = 1:na
        mu = (i-0.5)*dmu;
        dist =  muarray(i)/mu;
        data = [data; mu , dist];
    end

    % make plot
    stairs(data(:,1),data(:,2)/data(end,2),'-')
    xlabel('angle')
    ylabel('photo-dist','Rotation',0)
end
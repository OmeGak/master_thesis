function [total_interactions,tau_array,J_array,H_array,K_array,tau_history]...
        = Limb_Darkening(number_of_channels,number_of_photons,taumax,make_plot,compute_J)

    % number of channels
    na = number_of_channels;

    % number of photons
    nphot =  number_of_photons;
    
    muarray = zeros(1,na);
    dmu = 1./na;

    nbins = 201;
    taumin = 0;
    dtau = (taumax-taumin)/nbins;
    tau_array = linspace(taumin,2*taumax,nbins);
    J_array = zeros(1,nbins);
    H_array = zeros(1,nbins);
    K_array = zeros(1,nbins);
    
    total_interactions = 0;
    new_photon = 0;
    
    tau_history= [];
    % loop over all photons
    for l = 1:nphot
%         display('*** *** *** **** *** NEW PHOTON *** *** *** **** ***')
%         display(l)
        
        tau = taumax;
        
        one_photon_tau_history = tau;

        % follow the path of the photon through atmosphere,
        % it finally escapes under angle MU

        number_interactions = 0;
        forget_photon = 0;
        while (tau >= 0) 
            tau_old = tau;
            
            % angle
            x = rand();

            % optical depth
            x2 = rand();

            if (tau >= taumax)   % photon hits star again
                    % release a new photon
                    forget_photon = 1;
                    new_photon = new_photon + 1;
                    mu = sqrt(x);
                    tau = taumax;
            else
                mu = 2*x- 1;
            end

            tau_i = -log(x2);
            tau = max(tau - tau_i*mu,-1);      
            number_interactions = number_interactions + 1;
            one_photon_tau_history = [one_photon_tau_history; tau];
            
            % compute J,H,K(tau)
%             display([tau_old,tau,sign(mu)]);
                    
            index_min = min(floor((tau_old-taumin)/dtau) , floor((tau-taumin)/dtau)) + 2;
            index_max = max(floor((tau_old-taumin)/dtau) , floor((tau-taumin)/dtau)) + 1;  
            if tau == taumax
                index_max = nbins;
            end
            if index_max > nbins
                index_max = nbins;
            end
            if index_min < 1
                index_min = 1;
            end
            
            if (compute_J == 1)
                if abs(mu) > 10^(-3)
                    J_array(index_min:index_max) = J_array(index_min:index_max) + 1/abs(mu);
                end
                H_array(index_min:index_max) = H_array(index_min:index_max) + sign(mu);
                K_array(index_min:index_max) = K_array(index_min:index_max) + abs(mu);
            end    
            % END compute J,H,K(tau)
        end
        
        total_interactions = total_interactions + number_interactions;
        tau_history = update_tau_history(tau_history,one_photon_tau_history);
        
        % tally the photons according to mu
        k = 1;
        dummy = dmu;
        while ((mu - dummy) > 0)
            dummy = dmu*(k+1);
            k = k + 1;
        end
        muarray(k) = muarray(k) + 1;    
    end
    total_interactions = total_interactions/nphot;
    

    
    
    display('__________________________________________________________________')
    
    
    % simple test for one aspect of the correctness of the program: are
    % there photons lost?
    isum = 0;
    for i=1:na
        isum = isum + muarray(i);
    end
    if ~(isum == nphot)
        display('er is een foton verloren');
    end
    
    % make plot
    if make_plot == 1
        data = [];
        for i = 1:na
            mu = (i-0.5)*dmu;
            dist =  muarray(i)/mu;
            data = [data; mu , dist];
        end
        stairs(data(:,1),data(:,2)/data(end,2),'-')
        xlabel('angle')
        ylabel('photo-dist','Rotation',0)
    end
end
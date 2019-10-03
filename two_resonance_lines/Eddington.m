function xmuestart = Eddington()
    % use accept-reject method
    func = @(mu) 5/2.*(2/5+3/5.*mu).*mu;
    number_samples = 1;

    accepted_samples = zeros(1,number_samples);

    k = 0;
    l = 1;
    while k < number_samples
        X = accept_reject(func);
        if length(X) > 0
            xmuestart = X; 
            k = k + 1;
        end
        l = l +1;
    end

    efficiency = k/l;
end
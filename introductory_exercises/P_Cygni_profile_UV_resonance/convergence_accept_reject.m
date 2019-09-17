clc, clear all, close all

save = 1

min_exponent = 3
max_exponent = 6
variance_collection = zeros(1,max_exponent-min_exponent)
for n=min_exponent:max_exponent
    
    %func = @(x) 2*x;
    func = @(x) sin(x)/(1-cos(1));
    number_samples = 10^n;
    accepted_samples = zeros(1,number_samples);

    k = 1;
    l = 1;
    while k < number_samples
        X = accept_reject(func);
        if length(X) > 0
            accepted_samples(k) = X; 
            k = k + 1;
        end
        l = l +1;
    end

    efficiency = k/l;
    
    numBins = 100;
    h = histogram(accepted_samples,'Normalization','pdf','BinWidth',1/numBins)
    
    varArray = linspace(0,1,100);
    variance = sum((h.Values - func(varArray)).^2)
    
    variance_collection(n-(min_exponent-1)) = variance
end   

% make a plot
close all
figure()
MC_number = 10.^(min_exponent:max_exponent);
loglog(MC_number,variance_collection)
hold on, loglog(MC_number,1./sqrt(MC_number),'--')

if save == 1
    saveas(gcf,'convergence_accept_reject.png')
end
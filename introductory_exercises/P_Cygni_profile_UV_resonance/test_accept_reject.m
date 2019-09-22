clc, clear all, close all

%func = @(x) 2*x;
func = @(x) sin(x)/(1-cos(1));
number_samples = 10000;
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
    
efficiency = k/l

% make plot
figure()
numBins = 100;
h = histogram(accepted_samples,'Normalization','pdf','BinWidth',1/numBins)
x_values = linspace(0,1);
hold on, plot(x_values,func(x_values))
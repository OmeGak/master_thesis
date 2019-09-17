clc, clear all, close all

save = 1

A = 2.5
func = @(x) A*(0.4+0.6.*x).*x;
number_samples = 10^4;

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

numBins = 50;

figure()
h = histogram(accepted_samples,'Normalization','pdf','BinWidth',1/numBins)
x_array = linspace(0,1,100);
hold on, plot(x_array,func(x_array))

xlabel('\mu')
ylabel('p(\mu)')
legend('experimental','theoretical')

if save == 1
    saveas(gcf,'Eddington_accept_reject.png')
end

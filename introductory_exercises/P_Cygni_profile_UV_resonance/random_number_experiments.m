clc, clear all, close all

number_photons = 10^2

mu = zeros(1,number_photons)
I = zeros(1,number_photons)

for n=1:number_photons
    mu(n) = mu_isotropic_flux();
    I(n) = 1/mu(n);
end

figure()

subplot(1,2,1)
h_mu = histogram(mu)
h_mu.Normalization = 'probability'
hold on, plot(linspace(0,1,20),0:20:1,'--')

subplot(1,2,2)
h_I = histogram(I)
h_I.Normalization = 'probability'
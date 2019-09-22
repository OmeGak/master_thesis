clc, clear all, close all

save = 0;

number_of_channels = 20
number_of_photons = 10^5

tau_collection = (2).^(-5:5)
number_interactions_collection = zeros(1,length(tau_collection));

for k=1:length(tau_collection)
    tau = tau_collection(k);
    number_interactions_collection(k) = Limb_Darkening(number_of_channels, number_of_photons, tau)
end

close all
figure()
loglog(tau_collection,number_interactions_collection,'*--')
hold on, plot(tau_collection,tau_collection.^2)
hold on, plot(tau_collection,tau_collection)

xlabel('\tau')
ylabel('N','Rotation',0)
title('number of interactions versus opacity')
legend('experiment','\tau^2','\tau','Location','SouthEast')

if save == 1
    saveas(gcf,'data/N_vs_opacity.png')
end
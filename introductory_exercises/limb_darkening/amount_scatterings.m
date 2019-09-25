clc, clear all, close all

save = 0;

number_of_channels = 20
number_of_photons = 10^5

tau_collection = (2).^(-5:5)
number_interactions_collection = zeros(1,length(tau_collection));

for k=1:length(tau_collection)
    tau_max = tau_collection(k);
    release_new_photon_option = 1;
    make_plot = 0;
    number_interactions_collection(k) = Limb_Darkening(number_of_channels,number_of_photons,tau_max,release_new_photon_option, make_plot)
    %number_interactions_collection(k) = iets(1,end)
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
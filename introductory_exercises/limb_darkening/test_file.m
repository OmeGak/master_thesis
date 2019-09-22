clc, clear, close all

%% 1D case
number_of_channels = 20
number_of_photons = 10^5
maximum_optical_depth = 10

Limb_Darkening(number_of_channels,number_of_photons,maximum_optical_depth)

save = 1
if save == 1
    tit = ['number_channels',num2str(number_of_channels),'number_photons',num2str(number_of_photons),'max_opt_depth',num2str(maximum_optical_depth),'.png']
    saveas(gcf,tit)
end

%% 3D case
clc, clear, close all

number_of_channels = 20
number_of_photons = 10^5
maximum_optical_depth = 10

Limb_Darkening_3D(number_of_channels,number_of_photons,maximum_optical_depth)

save = 1
if save == 1
    tit = ['data/LD_3D_mu_number_channels',num2str(number_of_channels),'number_photons',num2str(number_of_photons),'max_opt_depth',num2str(maximum_optical_depth),'.png']
    saveas(figure(1),tit)
    tit = ['data/LD_3D_phi_number_channels',num2str(number_of_channels),'number_photons',num2str(number_of_photons),'max_opt_depth',num2str(maximum_optical_depth),'.png']
    saveas(figure(2),tit)
end
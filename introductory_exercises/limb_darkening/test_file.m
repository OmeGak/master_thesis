clc, clear, close all

number_of_channels = 20
number_of_photons = 10^5
maximum_optical_depth = 10

Limb_Darkening(number_of_channels,number_of_photons,maximum_optical_depth)

save = 1
if save == 1
    tit = ['number_channels',num2str(number_of_channels),'number_photons',num2str(number_of_photons),'max_opt_depth',num2str(maximum_optical_depth),'.png']
    saveas(gcf,tit)
end

%%
clc, clear, close all

number_of_channels = 20
number_of_photons = 10^5
maximum_optical_depth = 2

Limb_Darkening(number_of_channels,number_of_photons,maximum_optical_depth)
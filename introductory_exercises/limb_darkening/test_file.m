%% 1D case
clc, clear, close all

make_save = 1;
make_plot = 1;

number_of_channels = 100;
number_of_photons = 10^5;
tau_max = 10;

compute_J = 1;

[total_interactions,tau_array,J_array,tau_history] = ...
    Limb_Darkening(number_of_channels,number_of_photons,tau_max, make_plot, compute_J);

% make plot
plot_ref=  1;
if plot_ref == 1
    mu_array = linspace(0,1,10);
    intensity = 0.4+0.6.*mu_array;
    hold on, plot(mu_array,intensity)
    
    legend('Monte Carlo computation', 'Eddington-Barbier approximation','Location','SouthEast')
end

if make_save == 1
    tit = ['data/number_channels',num2str(number_of_channels),'number_photons',num2str(number_of_photons),'max_opt_depth',num2str(tau_max),'.png'];
    saveas(gcf,tit)
end

%% make plot of J
if compute_J == 1
    figure()
    plot(tau_array,J_array)
    xlabel('\tau')
    ylabel('J(\tau)','Rotation',0)
    if make_save == 1
        tit = ['figures/J_vs_tau_nphot',num2str(number_of_photons),'.png']
        saveas(gcf,tit)
    end
    
    figure()
    plot(tau_history(1:300,1))
    title('some photon histories')
    K = 3;
    for k= 2:K
        hold on, plot(tau_history(1:300,k))   
    end
    xlabel('scattering events')
    ylabel('scattering location','Rotation',0,'Position',[0 12])
    if make_save == 1
        tit = ['figures/photon_path_tau_nphot',num2str(number_of_photons),'.png']
        saveas(gcf,tit)
    end
end

display('__________________________________________________________________')
mean_number_scatterings = nnz(tau_history)/number_of_photons


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
clc, clear all, close all

test_number = 0
[freq, flux, number_scatterings, photon_path] = test_file(test_number);


%% track path of the photon
clc, close all
display('track path of the photons')

figure(), hold on
for phot = 1:10
    photon_path(:,phot)
    phot_loc_x = [0];
    phot_loc_y = [0];
    phot_number_scatterings = (length(photon_path(:,phot))-4)/2 + 1
    for k = 1:2:phot_number_scatterings
        loc_x = photon_path(3,phot)*photon_path(2,phot);
        loc_y = photon_path(3,phot)*sign(photon_path(2,phot))*sqrt(1-photon_path(2,phot)^2);
        phot_loc_x = [phot_loc_x, phot_loc_x(end) + loc_x];
        phot_loc_y = [phot_loc_y, phot_loc_y(end) + loc_y];
    end
    % neem nog een eindstraal van 1
    loc_x = photon_path(end,phot);
    loc_y = sign(photon_path(end,phot))*sqrt(1-photon_path(end,phot)^2);
    phot_loc_x = [phot_loc_x, phot_loc_x(end) + loc_x];
    phot_loc_y = [phot_loc_y, phot_loc_y(end) + loc_y];
    plot(phot_loc_x,phot_loc_y,'.-','MarkerSize',20)
end

%% save reference solution
clc, clear all, close all

test_number = 0
[freq, flux, number_scatterings, photon_path] = test_file(test_number);
save('reference_data/freq.mat','freq');
save('reference_data/flux.mat','flux');

%% inspect reference solution (test_number = 0)
clc, close all 

freq = matfile('reference_data/freq.mat');
    freq = freq.freq;
flux = matfile('reference_data/flux.mat');
    flux = flux.flux;

figure
plot(freq,flux)

%% test properties of the simulation (expected scattering ratio)
clc, clear all, close all

nphot = 10^5;
xk0 = 100;
alpha = 0;
beta = 1;
nbins = 110;

[nchan,vmax,vmin,deltax,freq,flux,b,xmax,rmax,nin,nout] = param_init(nphot,xk0,alpha,beta,nbins)
expected_scattering_ratio = (vmax-vmin)/(2*xmax)

%% make comparison plots
clc, clear all, close all

yes_old = matfile('data/yes_old.mat');
yes_old = yes_old.yes;

yes_new = matfile('data/yes_new.mat');
yes_new = yes_new.yes;

figure()
subplot(1,2,1)
plot(yes_old(1,1:100),'.-','MarkerSize',20)
hold on, plot(yes_new(1,1:100),'.-','MarkerSize',20)
title('xmuestart')

subplot(1,2,2)
plot(yes_old(2,1:100),'.-','MarkerSize',20)
hold on, plot(yes_new(2,1:100),'.-','MarkerSize',20)
title('xnew')

legend('original','new')

%% test Eddington_limb_darkening_distribution (with accept-reject)
clc, clear all, close all

make_save = 0;

K = 10^4;
x = zeros(1,K);
for k=1:K
    x(k) = Eddington_limb_darkening_distribution();
end

numBins = 50;

figure()
x_array = linspace(0,1,100);
func = @(x) 5/2.*x.*(2/5+3/5.*x);
h = histogram(x,'Normalization','pdf','BinWidth',1/numBins);
hold on, plot(x_array,func(x_array))

xlabel('\mu')
ylabel('p(\mu)')
legend('experimental','theoretical')

if make_save == 1
    saveas(gcf,'data/Eddington_accept_reject_converges_to_desired_dist.png')
end
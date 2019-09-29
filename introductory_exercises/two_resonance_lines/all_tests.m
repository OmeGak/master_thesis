clc, clear all, close all

test_number = 5
[freq, flux_two, number_scatterings, photon_path] = test_file(test_number);


%%
figure()

subplot(1,2,1)
plot(photon_path(1,1:100))
title('xstart')

subplot(1,2,2)
plot(photon_path(2,1:100))
title('xmuestart')

%% test properties of the simulation
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
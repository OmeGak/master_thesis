% let us now implement a decent fix of the problem


%% HALLO
clc, clear all, close all

test_number = 11
[freq_a, flux_a, number_scatterings_a, photon_path_a] = test_file(test_number);

test_number = 12
[freq_b, flux_b, number_scatterings_b, photon_path_b] = test_file(test_number);

%%
figure()
histogram(photon_path_a(3,:))


%% test scatter
clc, clear all, close all

K = 10^4;
all_phot_x = zeros(1,K);

xmuestart = 1;
beta = 1;
alpha = 0;
b = 1;
rmax = 10;
xk0 = 100;
nin = 0;
resonance_x = 0;
r_init = 1;
all_radial = 0;
isotropic_scattering = 1;
nsc = 0;
photon_path = zeros(1,K);
xstart_coll = zeros(1,K);


for k = 1:K
    phot = k;
    xstart = -0.8*rand;
    r = best_line(xmuestart,xstart,resonance_x,r_init,rmax,b,beta);
    [xnew,xmueou] = scatter(xstart,xmuestart,r,b,xk0,beta,alpha,all_radial,nsc,isotropic_scattering,nin)
    all_phot_x(k) = xnew;
    xstart_coll(k) = xstart;
end

figure()
subplot(1,2,1)
histogram(xstart_coll,'NumBins',100) 
title('xstart')

subplot(1,2,2)
histogram(all_phot_x,'NumBins',100) 
title('xnew')

%% plot scattering probability
% DOES NOT WORK

clc, clear all, close all

x = linspace(-1,1,100);
r = 1./(1-x);
p = (1-exp(-1./(1+x.^2./r)))./(1./(1+x.^2./r));
p_tau = (1-exp(-x))./x;

figure()
subplot(1,2,1)
plot(x,p)
subplot(1,2,2)
plot(x,p_tau)


%% test make_scattering_multiple_lines(xstart,xmuestart,beta,alpha,b,rmax,xk0,nin,resonance_x,r_init,all_radial,isotropic_scattering,nsc,photon_path,phot);       
clc, clear all, close all

K = 1000;
all_phot_x = zeros(1,K);

xmuestart = 1;
beta = 1;
alpha = 0;
b = 1;
rmax = 10;
xk0 = 100;
nin = 0;
resonance_x = 0;
r_init = 1;
all_radial = 0;
isotropic_scattering = 1;
nsc = 0;
photon_path = zeros(1,K);

for k = 1:K
    phot = k;
    xstart = -1+rand;
    [xnew,r,nin,last_scatter,xmueou,nsc,photon_path] = make_scattering_multiple_lines(xstart,xmuestart,beta,alpha,b,rmax,xk0,nin,resonance_x,r_init,all_radial,isotropic_scattering,nsc,photon_path,phot);       
    all_phot_x(k) = xnew;
end

figure()
histogram(all_phot_x,'NumBins',100) 

%% test main program (muliple_lines.m)
% more specifically, test what happens in different circumstances
clc, clear all, close all

test_number = 11
[freq_a, flux_a, number_scatterings_a, photon_path_a] = test_file(test_number);

test_number = 12
[freq_b, flux_b, number_scatterings_b, photon_path_b] = test_file(test_number);

figure()
subplot(2,2,1)
histogram(photon_path_a(3,:));
hold on, histogram(photon_path_a(1,:));
legend('xnew','xstart')

subplot(2,2,2)
histogram(photon_path_b(3,:));
hold on, histogram(photon_path_b(1,:));
legend('xnew','xstart')

subplot(2,2,3)
histogram(photon_path_a(4,:))

subplot(2,2,4)
histogram(photon_path_b(4,:))

%% test best_line(xmuestart,xstart,resonance_x,r_init,rmax,b,beta)
clc, clear all, close all

xmuestart = 1;
resonance_x = 0;
r_init = 1;

beta = 1;
nbins = 100;
case_number = 1;
nphot = 10^4;

[~,~,~,~,~,~,b,xmin,~,rmax,~,~] = param_init(beta,nbins,resonance_x,case_number,nphot);

xstart = 0.9;
r = best_line(xmuestart,xstart,resonance_x,r_init,rmax,b,beta)


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
%% very SIMPLE test
clc, close all, clear all

test_number = 21;
[freq,flux_two,number_scatterings,photon_path,yes,luminosity,rmax,total_number_backscatterings] = test_file(test_number);

photon_path(:,18:25)

%% SIMPLE test
clc, clear all, close all

make_save = 0;

test_number = 2001;
[freq,flux_two,number_scatterings,photon_path,yes,luminosity,rmax,total_number_backscatterings] = test_file(test_number);

% make plot and figure
if make_save == 1
    if test_number == 2001
        title1 = 'figures/multiple_lines_distant_diff_opacity.png';
        title2 = 'figures/multiple_lines_photon_path_distant_diff_opacity.png';
    elseif test_number == 200
        title1 = 'figures/multiple_lines_distant.png';
        title2 = 'figures/multiple_lines_photon_path_distant.png';
    elseif test_number == 500
        title1 = 'figures/multiple_lines_MANY.png';
        title2 = 'figures/multiple_lines_photon_path_MANY.png';        
    else
        title1 = 'figures/multiple_lines.png';
        title2 = 'figures/multiple_lines_photon_path.png';
    end
    saveas(figure(1),title1)
    saveas(figure(2),title2)
end

%% derive scattering probabilty
clc, clear all, close all

beta = 1; nbins = 100; resonance_x = [-0.5,0]; compare_Fortran = 1;
[~,~,~,~,~,~,~,~,~,~,~,~,~,~,~,expected_ratio] = param_init(beta,nbins,resonance_x,compare_Fortran);    

p = expected_ratio*(1+0.5/2*(1+0.5/2))
p = expected_ratio*(1+0.5/2*(1+0.5/2*(1+0.5/2*(1+0.5/2))))


%% test how Matlab works with arrays
clc, clear all, close all 

N = 21;
a = linspace(10,30,N);
b = a;

% do modification
a(10:15) = a(10:15) + 1;
b(15:10) = b(15:10) + 1;

% check if these are the same
verschil = a - b;

%% test xmueout(xk0,alpha,r,v,sigma,all_radial)
xk0 = 100
alpha = 0
r = 1
v = 1
sigma = 1
all_radial = 0

K = 10^4;
for k = 1:K
    xmueou(k) = xmueout(xk0,alpha,r,v,sigma,all_radial);
end

figure()
histogram(xmueou)

%% test scattering distribution
clc, clear all, close all

nphot = 10^3;
xstart_collection = linspace(-0.8,0,nphot);

resonance_x = 0;
x_selected = resonance_x;
tau_selected  = 100;

r = 1;
xk0 = 100;

xmuestart = 1;
beta = 1;
alpha = 0;
nbins = 100;
all_radial = 0;
nsc = 0;
isotropic_scattering = 0;
nin = 0;


[ ~,~,~,~,~,~,b,~,~,~,~,~,~,~,~,~] = param_init(beta,nbins,resonance_x,nphot); 

xnew_collection = zeros(1,nphot)
for phot = 1:length(xstart_collection)
    xstart = xstart_collection(phot)
    [xnew,xmueou] = scatter(xstart,x_selected,tau_selected,xmuestart,r,b,xk0,beta,alpha,all_radial,nsc,isotropic_scattering,nin);
    xnew_collection(phot) = xnew;
end

figure()
subplot(1,2,1)
histogram(xstart_collection,'Normalization','pdf')
subplot(1,2,2)
histogram(xnew_collection,'Normalization','pdf')


%% test influence of xk0
clc, clear all, close all

save_plot = 1;

test_number_a = 25
[freq_a, flux_a, number_scatterings_a, photon_path_a] = test_file(test_number_a);
if save_plot == 1
    saveas(gcf,['figures/situation_',num2str(test_number_a),'.png'])
end

test_number_b = 26
[freq_b, flux_b, number_scatterings_b, photon_path_b] = test_file(test_number_b);
if save_plot == 1
    saveas(gcf,['figures/situation_',num2str(test_number_b),'.png'])
end

% make joint plot
figure()
plot(freq_a,flux_a,'.-')
hold on, plot(freq_b,flux_b,'.-')
legend('xk0=100','xk0=0.5')

if save_plot == 1
    saveas(gcf,['figures/situation_',num2str(test_number_a),'_',num2str(test_number_b),'.png'])
end


%% test best_line(xmuestart,xstart,resonance_x,r_init,rmax,b,beta)
    % does it really correspond to the lowes frequency?
    % for photons streaming in both directions?
clc, clear all, close all

xmuestart = 1;
resonance_x = [0,1,2];
resonance_tau = 100*ones(1,3);
r_init = 1;

compare_Fortran = 1;

beta = 1;
nbins = 100;
case_number = 1;
nphot = 10^4;
nsc = 0;

[~,vmin,vmax,~,~,~,b,xmin,~,rmax,~,~,~] = param_init(beta,nbins,resonance_x,nphot,compare_Fortran); 

xstart = 0.5;
[r,x_selected,tau_selected] = best_line(xmuestart,xstart,resonance_x,resonance_tau,r_init,rmax,b,beta,nsc,vmin,vmax)


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
    

%% test if multiple scatterings from one line are possible
clc,  clear all

test_number = 0;                                   
[freq,flux_two,number_scatterings,photon_path,yes,luminosity,rmax,total_number_backscatterings] = test_file(test_number);


%% ancient version
clc, clear all, close all

xk0 = 100
nphot = 10^5
alpha = 0
beta = 1

make_plot = 1;
save = 0;
all_radial = 0;
radial_release = 1;

[freq_b,flux_b,yes] = one_radial_line(nphot , xk0 , alpha , beta , make_plot , save , all_radial, radial_release);    

%% simple test for line selection
clc, clear all, close all

xmuestart = 1;
xstart = -0.9180;
resonance_x = [-0.5,0];
resonance_tau = [100,100];

r_init = 1;
rmax = 100;
beta = 1;
vmin = -0.98;
vmax = -0.01;
b = 1-vmin*(1/beta);

display('hier gaan we dan')
[r,x_selected,tau_selected,last_scatter] = best_line(xmuestart,xstart,resonance_x,resonance_tau,r_init,rmax,b,beta,vmin,vmax)

% test influence of xk0 on r
xstart = -0.5;

resonance_x = 0;
resonance_tau = 100;

[r_a,x_selected,tau_selected,last_scatter] = best_line(xmuestart,xstart,resonance_x,resonance_tau,r_init,rmax,b,beta,vmin,vmax)

resonance_tau = 0.5;
[r_b,x_selected,tau_selected,last_scatter] = best_line(xmuestart,xstart,resonance_x,resonance_tau,r_init,rmax,b,beta,vmin,vmax)

%% test superposition
clc, clear all, close all

save_figures = 0;
multiplication = 1;
test_number_1 = 18;
test_number_2 = 19;
test_number_3 = 20;
overlap_number = 25;
test_superposition(save_figures,multiplication,test_number_1,test_number_2,test_number_3,overlap_number);

save_fig = 1
xmueout_only_pos = 1
if save_fig == 1
    if xmueout_only_pos == 1
        saveas(gcf,'figures/multiplication_vs_complex_interactions_xmueout_pos.png')
    else
        saveas(gcf,'figures/multiplication_vs_complex_interactions_xmueout_iso.png')
    end
end

%% very SIMPLE test
clc, clear all, close all

test_number = 21;                                   
[freq,flux,total_number_scatterings,photon_path,yes,luminosity,rmax,total_number_backscatterings,...
    dLdr,g_radiation,scattering_x] = test_file(test_number);

display('_____________statistics for luminosity_________________')
photon_path(isnan(photon_path)) = 0;
count_first_x = 0;
count_second_x = 0;
number_scattered_photons = 0;
for k=1:size(photon_path,2)
    if isnan(scattering_x(1,k)) == 0
        if photon_path(max(find(photon_path(:,k))),k) == -0.5
            count_first_x = count_first_x + 1;
        else
            count_second_x = count_second_x + 1;
        end
        number_scattered_photons = number_scattered_photons + 1;
    end
end
count_first_x = count_first_x/number_scattered_photons
count_second_x = count_second_x/number_scattered_photons

%% test_convergence
clc, close all, clear all

range_max = 4;
make_save = 1;
close_all = 1;
test_convergence(range_max,make_save,close_all)


%% figures for paragraph 'EXPERIMENTS AND RESULTS. (1) AND (2)'
clc, close all, clear all

test_number = 1
[freq,flux_two,number_scatterings,photon_path,yes,luminosity,rmax,total_number_backscatterings] = test_file(test_number);

if test_number == -2
    saveas(gcf,'figures/scattering_distribution_radial_release.png')
elseif test_number == -1
    saveas(gcf,'figures/scattering_distribution_random_release.png')
elseif test_number == 0
    saveas(gcf,'figures/solution_random_release.png')
elseif test_number == 1
    saveas(gcf,'figures/solution_radial_release.png')
end

%% figures for paragraph 'EXPERIMENTS AND RESULTS. (3)'
clc, close all, clear all

test_number = 21
[freq,flux_two,number_scatterings,photon_path,yes,luminosity,rmax,total_number_backscatterings] = test_file(test_number);

if test_number == -2
    saveas(gcf,'figures/multiple_lines_distant.png')
end

%% testje over root finding (with angle correction)
clc, clear all, close all

angle_correction = 1

N = 200;
r = linspace(1,20,N);
p = 0.8;
beta = 1;
b = 2;
x = sqrt(1-(p./r).^2).*(1-b./r).^beta;
y = (1-b./r).^beta;
plot(r,x)
hold on, plot(r,y)

title('generic form of velocity profile from observers viewpoint')
xlabel('r')
ylabel('\mu v(r)','Rotation',0)
legend('angle correction','no angle correction','Location','Southeast')
xlim([1,20])

saveas(gcf,'figures/velocity_profile.png')
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
clc, clear all, close all

beta = 1; nbins = 100; nrbins = 100; resonance_x = 0; nphot = 10^4; compare_Fortran = 1;
[~,vmin,vmax,~,~,~,b,xmin,~,rmax,~,~,~] = param_init(beta,nbins,nrbins,resonance_x,compare_Fortran,nphot);

N = 100;

xmuestart = rand(1,N);
xmuein = 1;
xk0 = 100;
alpha = 0;

xstart = linspace(0.01,0.98,N);
x = linspace(-1,1,N);
r = b./(1-xstart.^(1/beta));

v = (1-b./r).^(beta);
dvdr = b*beta./r.^2.*(1-b./r).^(beta-1);
sigma = dvdr./(v./r)-1;
tau = xk0./(r.*v.^(2-alpha).*(1+xmuein^2*sigma));
            
xmueou = (1-exp(-tau))/tau

xnew = xstart + v.*(xmueou-xmuein)

% figure()
% plot(xstart,xnew)
% title('radial release')

figure()
histogram(xnew)



% simple (BUT INCORRECT) proposal
% px = 1-log(x)
% plot(x,px)

%% test xmueout(xk0,alpha,r,v,sigma,all_radial)
xk0 = 100
alpha = 0
r = 2
v = 3
sigma = 1
all_radial = 0

K = 10^4;
for k = 1:K
    xmueou(k) = xmueout(xk0,alpha,r,v,sigma,all_radial);
    if rand > 0.5
        xmueou = -xmueou;
    end
end

figure()
histogram(xmueou,'Normalization','pdf')

%% test_luminosity
clc, clear all, close all

test_number = 0;
[freq, flux_two, number_scatterings , photon_path , ~ , luminosity , ~, ~, dLdr ,~] = test_luminosity(test_number);

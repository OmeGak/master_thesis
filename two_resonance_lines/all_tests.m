%% test random number generation
clc, clear all, close all

N = 5;

rng(10)
random_numbers_a = zeros(1,N);
for n=1:N
    random_numbers_a(n) = rand;
end

rng(10)
random_numbers_b = zeros(1,N);
for n=1:N
    random_numbers_b(n) = test_random_number_generation;
end

display(random_numbers_a)
display(random_numbers_b)

%% do simple test

test_number = 21;
[freq, flux_two, number_scatterings,photon_path] = test_file(test_number);
a = photon_path(:,15:20);

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

%% compare with Fortran (FREELY TRANSLATED VERSION)
clc, clear all, close all

% FORTRAN DATA (generated through MATLAB)
    display('*****************FORTRAN DATA*****************')
    nphot = 10^5;
    xk0 = 100;
    alpha = 0;
    beta = 1;

    make_plot = 1;
    save = 0;
    all_radial = 0;

    [freq_a,flux_a,yes_a] = one_radial_line(nphot , xk0 , alpha , beta , make_plot , save , all_radial);   

% MATLAB DATA
    display('*****************MATLAB DATA*****************')
    test_number = 100;
    [freq_b, flux_b, number_scatterings,photon_path,yes_b] = test_file(test_number);
    
    iets = flux_b;
    for k =1:length(flux_b)
        flux_b(k) = iets(length(flux_b)-k+1);
    end
  
% JOINT PLOT
save_fig = 1;  
    display('*****************MAKE PLOT*****************')
    figure()
    plot(freq_a,flux_a)
    hold on, plot(freq_b,flux_b)

    legend('Fortran data','Matlab data')
    xlabel('x')
    ylabel('I')

    if save_fig == 1
        saveas(gcf,'figures/compare_Matlab_Fortran.png')
    end

% close all
% COMPARE THE DATA
    display('*****************COMPARE DATA*****************')
    % yes contains [xstart,xmuestart,rnew,xnew]
    N = 100
    selection_a = yes_a(:,N+1:N+10)
    selection_b = yes_b(:,N+1:N+10)

    
    %% compare with Fortran (LITERALLY TRANSLATED VERSION)
  
% 1) FORTRAN DATA
    display('FORTRAN DATA - -  - - - - - - - - - - - - -')
    data_folder = '../introductory_exercises/P_Cygni_profile_UV_resonance/'

        % get data
            % mamaaaa contains data for xmuestart=sqrt(rand)
            % generated on 9-10-2019 with (pcyg_original.f90)
        file_name = [data_folder,'data/mamaaaaa']
        test_case = 0;

        nphot = 10^5
        xk0 = 100
        alpha = 0
        beta = 1

        legend_1 = 'Sobolev scattering'

        % maybe it is desired to add other data
            other_file_name = [];
            % other_file_name = [data_folder,'data/out_8_10_2']
            legend_2 = []
            % legend_2 = 'isotropic scattering'
            name = []
            name = 'data/simple_test.png'

    [freq_a,flux_a] = read_out(file_name,other_file_name,test_case,nphot,xk0,alpha,beta,legend_1,legend_2,name);
    
    iets =  zeros(1,length(freq_a));
    for k=1:length(freq_a)
        iets(k) = freq_a(length(freq_a)-k+1);
    end
    freq_a = iets;

% 2) MATLAB DATA
    display('MATLAB DATA - - - - - - - - - - - ')

    nphot = 10^5
    xk0 = 100
    alpha = 0
    beta = 1

    make_plot = 1;
    save = 0;
    all_radial = 0

    [freq_b,flux_b,yes] = one_radial_line(nphot , xk0 , alpha , beta , make_plot , save , all_radial);    
    
% 3) JOINT PLOT
    figure()
    plot(freq_a,flux_a)
    hold on, plot(freq_b,flux_b)

    legend('Fortran data','Matlab data')
    xlabel('x')
    ylabel('I')

    if save_fig == 1
        saveas(gcf,'figures/compare_Matlab_Fortran.png')
    end    

%% track path of the photon
clc, close all, clear all
display('track path of the photons')

test_number = 21;
[freq, flux, number_scatterings, photon_path] = test_file(test_number);

Nphot = 20
figure(), hold on
c_map = jet(Nphot);
for phot = 1:Nphot
    % specify a color
    a = c_map(phot,:);
    
    % initial shooting
    phot_loc_x = [1 , 1+photon_path(3,phot)*photon_path(2,phot)];
    phot_loc_y = [1 , 1+photon_path(3,phot)*randi([-1,1])*sqrt(1-photon_path(2,phot)^2)];
    plot(phot_loc_x,phot_loc_y,'.-','MarkerSize',20,'color',a)
    
    % other scattering events
    phot_number_scatterings = (length(photon_path(:,phot))-4)/2 + 1;
    if phot_number_scatterings >= 2
        for k = 2:2:phot_number_scatterings
            phot_loc_x = [phot_loc_x, phot_loc_x(end) + photon_path(3,phot)*photon_path(2,phot)];
            phot_loc_y = [phot_loc_y, phot_loc_y(end) + photon_path(3,phot)*randi([-1,1])*sqrt(1-photon_path(2,phot)^2)];
        end
        plot(phot_loc_x,phot_loc_y,'.-','MarkerSize',20,'color',a)
    end

    % neem nog een eindstraal van 1
    phot_loc_x = [phot_loc_x(end), phot_loc_x(end) + photon_path(end,phot)];
    phot_loc_y = [phot_loc_y(end), phot_loc_y(end) + sign(photon_path(end,phot))*sqrt(1-photon_path(end,phot)^2)];
    plot(phot_loc_x,phot_loc_y,'--','MarkerSize',20,'color',a)
end
x = linspace(-1,1,20);
hold on, plot(x,1+sqrt(1-x.^2),'color','yellow','LineWidth',4)
hold on, plot(x,1-sqrt(1-x.^2),'color','yellow','LineWidth',4)

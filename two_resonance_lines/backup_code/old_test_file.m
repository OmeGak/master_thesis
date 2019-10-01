%% test one_radial_line.m
clc, clear all, close all

nphot = 10^4
xk0 = 100
alpha = 0
beta = 1

all_radial = 0;

make_plot = 1
save = 1

[freq,flux,yes] = one_radial_line(nphot , xk0 , alpha , beta , make_plot , save,all_radial)
clear save, save('data/yes_old.mat','yes')

%% test one_RADIAL_line_beta_version.m
clc, clear all, close all

nphot = 10^4
xk0 = 100
alpha = 0
beta = 1

all_radial = 0;

make_plot = 1
save_plot = 1

[freq, flux_one_radial] = one_radial_line_beta_version(nphot , xk0 , alpha , beta , make_plot , save_plot,all_radial);
save('flux_one_radial.mat','flux_one_radial')


%% test one_RADIAL_line_gamma_version.m
clc, clear all, close all

nphot = 10^5
xk0 = 100
alpha = 0
beta = 1
possibility_scattering = 1;
nbins = 100;

all_radial = 0;

make_plot = 1
make_save = 1

[freq, flux_one_radial] = one_radial_line_gamma_version(nphot,xk0,alpha,beta,make_plot,make_save,possibility_scattering,nbins,all_radial);
if possibility_scattering == 0
    flux_simple_sink = flux_one_radial
    save('flux_simple_sink.mat','flux_simple_sink')
end


%% make comparision plot
clc, clear all, close all

flux_one_radial = matfile('flux_one_radial.mat');
flux_two_radial = matfile('flux_two_radial.mat');
flux_simple_sink = matfile('flux_simple_sink.mat');

figure()
plot(flux_one_radial.flux_one_radial)
hold on, plot(flux_two_radial.flux_two_radial)
hold on, plot(flux_simple_sink.flux_simple_sink)

legend('one line, radial','two lines (radial)','well')


%% make comparision plot
clc, clear all, close all

flux_one_radial = matfile('flux_one_radial.mat');
flux_two_radial = matfile('flux_two_radial.mat');
flux_simple_sink = matfile('flux_simple_sink.mat');
flux_two = matfile('flux_two.mat');

figure()
plot(flux_one_radial.flux_one_radial)
hold on, plot(flux_two_radial.flux_two_radial)
hold on, plot(flux_simple_sink.flux_simple_sink)
hold on, plot(flux_two.flux_two)

legend('one line, radial','two lines (radial)','well','two lines')

%% plot Sobolev approximation function

clc, clear all, close all

pstart = 0;
b = 0.99;
beta = 1;
xstart = 0.2;

func = @(r) sqrt(1-(pstart./r).^2).*(1-b./r).^beta - xstart;
root_num = rtbis(func,1,2,10^(-5))
root_anal = b/(1-xstart^(1/beta))
root_ana_test = func(b/(1-xstart^(1/beta)))

x= linspace(1,2);
figure()
plot(x,func(x))
hold on, plot(x,0*x,'--')

title('Sobolev condition')
xlabel('r')
ylabel('func(r)')

%% about uniform random number
clc, clear all, close all

K = 10^4
a = rand(1,K)
a = a.*(-1).^(sign(rand(1,K)-0.5)==1)

nbins = 100
deltax = 2/nbins;;

xbins = linspace(-1,1,nbins)
flux = zeros(1,nbins)
for k = 1:K
    ichan = floor((1-a(k))/deltax)+1;
    flux(ichan) = flux(ichan) +1;
end

figure()
plot(xbins,flux/nbins,'.','MarkerSize',20)

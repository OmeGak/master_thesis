%% test one_radial_line.m
clc, clear all, close all

nphot = 10^4
xk0 = 100
alpha = 0
beta = 1

make_plot = 1
save = 1

one_radial_line(nphot , xk0 , alpha , beta , make_plot , save)


%% test one_radial_line_beta_version.m
clc, clear all, close all

nphot = 10^4
xk0 = 100
alpha = 0
beta = 1

make_plot = 1
save = 1

one_radial_line_beta_version(nphot , xk0 , alpha , beta , make_plot , save)

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

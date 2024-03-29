clc, clear all, close all

N = 100;
x = linspace(-1,1,N);

xk0 = 100;

beta = 1;
vmin = 0.01;
vmax = 0.98;
b = 1-vmin^(1/beta);
rmax = b/(1-vmax^(1/beta));

xmuestart = 1;
pstart = 0;
xmuein = 1;

r = 1./(1-x.^(-beta));
v = (1-b./r).^beta;

sigma = beta*b./r.*(1-b./r).^(-1)

tau = xk0./(r.*v.^2.*(1+sigma))

p = (1-exp(-tau))./tau


figure()
plot(x,r)
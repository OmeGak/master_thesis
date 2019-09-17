clc, clear all, close all

tau_0 = 10;
sigma = 2;

x = linspace(-1,1,100);
p = (1-exp(-tau_0./(1+x.^2*sigma)))./(tau_0./(1+x.^2*sigma));
plot(x,p)
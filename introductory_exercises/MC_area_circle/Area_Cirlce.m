clear, clc, close all

rng(1);

N  = 10^4;
xrn = rand(1,N);
yrn = rand(1,N);
x = 4.*xrn - 2;
y = 4.*yrn - 2;
area_sq = 16;
r = 1.2;

hit = 0;
for i = 1 : N
    if (x(i)^2 + y(i)^2 <= r^2)
        hit = hit + 1;
    end
end

area = hit/N * area_sq;

area
pi*r^2

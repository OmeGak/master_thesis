clc, clear, close all

% numerical parameters
nx = 100;
ny = 100;

tend = 1;
ntime = 40;

sol = ADI_2D_solver(nx,ny,tend,ntime)
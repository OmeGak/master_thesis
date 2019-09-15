% set xk0=0 and test convergence as number of photons increases

close all 

fileID = fopen('out','r')
formatSpec = '%f %f';
sizeA = [2 Inf];
A = fscanf(fileID,formatSpec,sizeA)
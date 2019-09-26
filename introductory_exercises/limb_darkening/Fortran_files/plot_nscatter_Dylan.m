clc, clear all, close all

file_name = 'scatter_list.txt'

fileID = fopen(file_name,'r')
formatSpec = '%f %f';
sizeA = [2 Inf];
A = fscanf(fileID,formatSpec,sizeA); 

nscat_x = linspace(A(1,1),A(1,end),100);
nscat_y = nscat_x + nscat_x.^2/2;

figure()
loglog(A(1,:),A(2,:),'.','MarkerSize',30)
hold on, loglog(nscat_x,nscat_y)
xlabel('\tau')
ylabel('N')
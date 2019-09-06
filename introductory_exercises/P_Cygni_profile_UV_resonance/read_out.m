% reads the output from the Fortran computations
close all

fileID = fopen('out','r')
formatSpec = '%f %f';
sizeA = [2 Inf];
A = fscanf(fileID,formatSpec,sizeA)

figure()
plot(A(1,:),A(2,:))
xlabel('x')
ylabel('flux','Rotation',0)
set(gca,'fontsize',14)


nphot = 10^6
xk0 = 100
alpha = 0
beta = 1
test_case = 1

if test_case == 0
    name = ['npot',num2str(log(nphot)/log(10)),'xk0',num2str(xk0),'alpha',num2str(alpha),'beta',num2str(beta),'test0.png']
elseif test_case == 1
    name = ['npot',num2str(log(nphot)/log(10)),'xk0',num2str(xk0),'alpha',num2str(alpha),'beta',num2str(beta),'test1.png']
elseif test_case == 2
    name = ['npot',num2str(log(nphot)/log(10)),'xk0',num2str(xk0),'alpha',num2str(alpha),'beta',num2str(beta),'test2.png']
elseif test_case == 3
    name = ['npot',num2str(log(nphot)/log(10)),'xk0',num2str(xk0),'alpha',num2str(alpha),'beta',num2str(beta),'test3.png']
end
saveas(gcf,name)



    
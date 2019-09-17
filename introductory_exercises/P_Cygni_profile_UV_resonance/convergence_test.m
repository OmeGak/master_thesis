% set xk0=0 and test convergence as number of photons increases

close all 

save = 1

number_tests = 7
var_collection = zeros(1,number_tests)
for k = 1:number_tests

    % open the data file
    name = ['out0_10E',num2str(k)];
    fileID = fopen(name,'r')
    formatSpec = '%f %f';
    sizeA = [2 Inf];
    A = fscanf(fileID,formatSpec,sizeA)

    % make nice plots
    figure()
    plot(A(1,:),A(2,:))
    xlabel('x')
    ylabel('flux','Rotation',0)
    set(gca,'fontsize',14)

    name = [name,'.png']
    if save == 1
        saveas(gcf,name)
    end
    
    % calculate variance, the exact value is isotropic (1)
    % the number of bins equals nchan = 100 (see Fortran code)
    nchan = 100
    var = 0
    for l = 1:nchan
        var = var + (A(2,k)-1)^2;
    end
    var = var/nchan
    
    var_collection(k) = var;
end

% make convergence plot
number_photons = 10.^(1:number_tests)
square_root_law = 1./sqrt(number_photons)
loglog(number_photons,var_collection)
hold on, loglog(number_photons,square_root_law)
xlabel('nphot')
ylabel('variance')
title('convergence analysis')
legend('experimental','$numberphotons^{0.5}$','Interpreter','latex')

if save == 1
    saveas(gcf,'test0_convergence.png')
end

function exponent = profile_convergence(number_tests,ref_profile,save,plot_least_squares)

    name = ['data/profile_convergence/out0_xk0100_10E',num2str(ref_profile)]
    fileID = fopen(name,'r')
    formatSpec = '%f %f';
    sizeA = [2 Inf];
    B = fscanf(fileID,formatSpec,sizeA)

    var_collection = zeros(1,number_tests)
    for k = 1:number_tests

        % open the data file
        name = ['data/profile_convergence/out0_xk0100_10E',num2str(k)];
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
            var = var + (A(2,l)-B(2,l))^2;
        end
        var = var/nchan

        var_collection(k) = var;
    end

    std_dev_collection = sqrt(var_collection);

    % make convergence plot
    number_photons = 10.^(1:number_tests)
    square_root_law = 1./sqrt(number_photons)

    figure()
    loglog(number_photons , std_dev_collection,'*--')
    hold on, loglog(number_photons , square_root_law)
    xlabel('nphot')
    ylabel('variance')
    title('convergence analysis')

    if save == 1
        saveas(gcf,'data/profile_convergence/test0_convergence.png')
    end
    
    % least-squares fit of a line through the points
    X = [log(number_photons)',ones(length(number_photons),1)];
    Y = log(std_dev_collection);
    params = X\Y';
    exponent = params(1)
    if plot_least_squares == 1
        hold on, loglog(number_photons, exp(params(2))*number_photons.^(params(1)),'--','LineWidth',2)
    end
    legend('experimental','$numberphotons^{0.5}$','least-squares fit','Interpreter','latex')
    
end
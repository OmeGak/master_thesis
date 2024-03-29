function comp_vars = compare_variance(k,save)
    % open the data file
    name = ['data/out5_10E7'];
    fileID = fopen(name,'r')
    formatSpec = '%f %f';
    sizeA = [2 Inf];
    out_fine = fscanf(fileID,formatSpec,sizeA);

    name = ['data/out5_10E',num2str(k),'_rand'];
    fileID = fopen(name,'r')
    formatSpec = '%f %f';
    sizeA = [2 Inf];
    out_rand = fscanf(fileID,formatSpec,sizeA);

    name = ['data/out5_10E',num2str(k),'_det'];
    fileID = fopen(name,'r')
    formatSpec = '%f %f';
    sizeA = [2 Inf];
    out_det = fscanf(fileID,formatSpec,sizeA);

    % make nice plots
    figure()
    plot(out_fine(1,:),out_fine(2,:))
    hold on, plot(out_det(1,:),out_det(2,:)) 
    hold on, plot(out_rand(1,:),out_rand(2,:)) 
    xlabel('x')
    ylabel('flux','Rotation',0)
    set(gca,'fontsize',14)
    legend('fine','det','rand')
    title(['line profile (10E',num2str(k),' photons)'])

    name = ['variance_trick_10E',num2str(k),'.png']
    if save == 1
        saveas(gcf,name)
    end

    % calculate variance, the exact value is isotropic (1)
    % the number of bins equals nchan = 100 (see Fortran code)
    nchan = 100

    var = 0;
    for l = 1:nchan
        var = var + (out_rand(2,l)-out_fine(2,l))^2;
    end
    var_rand = var/nchan

    var = 0;
    for l = 1:nchan
        var = var + (out_det(2,l)-out_fine(2,l))^2;
    end
    var_det = var/nchan

    comp_vars = [var_rand; var_det];
end
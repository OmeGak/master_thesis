function test_Eddington()
%% test Eddington_limb_darkening_distribution (with accept-reject)
    clc, clear all, close all

    make_save = 0;

    K = 10^4;
    x = zeros(1,K);
    for k=1:K
        x(k) = Eddington();
    end

    numBins = 50;

    figure()
    x_array = linspace(0,1,100);
    func = @(x) 5/2.*x.*(2/5+3/5.*x);
    h = histogram(x,'Normalization','pdf','BinWidth',1/numBins);
    hold on, plot(x_array,func(x_array))

    xlabel('\mu')
    ylabel('p(\mu)')
    legend('experimental','theoretical')

    if make_save == 1
        saveas(gcf,'data/Eddington_accept_reject_converges_to_desired_dist.png')
    end
end 
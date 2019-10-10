function test_superposition(save_figures)
    test_number = 18
    [freq_a, flux_a, number_scatterings_a, photon_path_a] = test_file(test_number);

    test_number = 19
    [freq_b, flux_b, number_scatterings_b, photon_path_b] = test_file(test_number);

    test_number = 20
    [freq, flux, number_scatterings, photon_path] = test_file(test_number);

    close all 

    freq_b_augmented = [linspace(-1,-0.5,25),freq_b]
    flux_b_augmented = [ones(1,25),flux_b]
    freq_a_augmented = [freq_a,linspace(1,1.5,25)]
    flux_a_augmented = [flux_a,ones(1,25)]
    freq_super = linspace(-1,1.5,125);
    flux_super = (flux_b_augmented + flux_a_augmented)/2

    figure()
    plot(freq,flux,'LineWidth',2)
    hold on, plot(freq_a_augmented,flux_a_augmented)
    hold on, plot(freq_b_augmented,flux_b_augmented)
    hold on, plot(freq_super,flux_super,'LineWidth',2)
    legend('complex intereactions','a','b','superposition','Location','southeast')
    xlabel('x')
    ylabel('I')
    if save_figures == 1
        saveas(gcf,'figures/superposition_test_with_extra.png')
    end

    figure()
    plot(freq,flux,'LineWidth',2)
    hold on, plot(freq_super,flux_super,'LineWidth',2)
    legend('complex intereactions','superposition')
    xlabel('x')
    ylabel('I')
    if save_figures == 1
        saveas(gcf,'figures/superposition_test.png')
    end
end
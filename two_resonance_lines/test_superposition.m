function test_superposition(save_figures,multiplication,test_number_1,test_number_2,test_number_3,overlap_number)

    make_ugly_plot = 1;
    
    % get data
        test_number = test_number_1
        [freq_a, flux_a, number_scatterings_a, photon_path_a] = test_file(test_number);

        test_number = test_number_2
        [freq_b, flux_b, number_scatterings_b, photon_path_b] = test_file(test_number);

        test_number = test_number_3
        [freq_s, flux_s, number_scatterings_s, photon_path_s] = test_file(test_number);

        close all 

    % create superposition    
        % the number N is a measure of the overlap percentage
        N = overlap_number;
        freq_b_augmented = [linspace(min(freq_a),min([freq_b,max(freq_a)]),N) , freq_b];
        flux_b_augmented = [ones(1,N) , flux_b];
        freq_a_augmented = [freq_a , linspace(max([freq_a,min(freq_b)]),max(freq_b),N)];
        flux_a_augmented = [flux_a , ones(1,N)];
        freq_super = linspace(min(freq_a),max(freq_b),length(freq_a)+overlap_number);
        flux_super = (flux_b_augmented + flux_a_augmented)/2;
        if multiplication == 1
            flux_super = (flux_b_augmented.*flux_a_augmented);
        end

    % make plot    
    if make_ugly_plot == 1
        figure()
        plot(freq_s,flux_s,'LineWidth',2)
        hold on, plot(freq_a_augmented,flux_a_augmented)
        hold on, plot(freq_b_augmented,flux_b_augmented)
        hold on, plot(freq_super,flux_super,'LineWidth',2)
        legend('complex intereactions','a','b','superposition','Location','southeast')
        xlabel('x')
        ylabel('I')
        if save_figures == 1
            saveas(gcf,'figures/superposition_test_with_extra.png')
        end
    end

    figure()
    plot(freq_s,flux_s,'LineWidth',2)
    hold on, plot(freq_super,flux_super,'LineWidth',2)
    legend('complex intereactions','superposition')
    xlabel('x')
    ylabel('I')
    if save_figures == 1
        saveas(gcf,'figures/superposition_test.png')
    end
end
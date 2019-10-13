function test_multiple_opacities(make_save)

    % get data
        test_number = 30
        [freq_a, flux_a, number_scatterings_a, photon_path_a] = test_file(test_number);

        test_number = 31
        [freq_b, flux_b, number_scatterings_b, photon_path_b] = test_file(test_number);
        
    % make figure
        figure()
        plot(freq_a,flux_a)
        hold on, plot(freq_b,flux_b)
        
        xlabel('x')
        ylabel('I')
        legend('xk0=100','xk0=0.5')
        
        if make_save == 1
            saveas(gcf,'figures/test_multiple_opacities.png')
        end
end
function save_reference_solution()
    test_number = 24
    [freq, flux, number_scatterings, photon_path] = test_file(test_number);

    % save figure
    saveas(gcf,'figures/reference_solution_xmuestart.png')

    % save data
    save('reference_data/freq.mat','freq');
    save('reference_data/flux.mat','flux');

    %% inspect reference solution (test_number = 0)
    clc, close all 

    freq = matfile('reference_data/freq.mat');
        freq = freq.freq;
    flux = matfile('reference_data/flux.mat');
        flux = flux.flux;

    figure
    plot(freq,flux)
    
end
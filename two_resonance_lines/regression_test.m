function test_OK = regression_test()
    clc, clear all, close all
    
    test_OK = 0;

    test_number = 0
    [freq, flux, number_scatterings, photon_path] = test_file(test_number);

    ACC = 10^(-2);

    % save one profile that is said to be 'accurate'
    % open that file
    ref_freq = matfile('reference_data/freq.mat');
        ref_freq = ref_freq.freq;
    ref_flux = matfile('reference_data/flux.mat');
        ref_flux = ref_flux.flux;

    % determine variance w.r.t that profile
    nbin = length(ref_freq);

    variance = 0;
    for bin = 1:nbin
        variance = variance + (flux(bin) - ref_flux(bin))^2;
    end
    if variance < ACC
        test_OK = 1;
    end
end
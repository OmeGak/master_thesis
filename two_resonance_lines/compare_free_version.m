function compare_free_version()
    %% compare with Fortran (FREELY TRANSLATED VERSION)
    clc, clear all, close all

    test_number = 31;
    xk0 = 0.5;

    % test_number = 0;
    % xk0 = 100;

    % FORTRAN DATA (generated through MATLAB)
        display('*****************FORTRAN DATA*****************')
        nphot = 10^5;
        alpha = 0;
        beta = 1;

        make_plot = 1;
        save = 0;
        all_radial = 0;

        [freq_a,flux_a,yes_a] = one_radial_line(nphot , xk0 , alpha , beta , make_plot , save , all_radial);   

    % MATLAB DATA
        display('*****************MATLAB DATA*****************')
        [freq_b, flux_b, number_scatterings,photon_path,yes_b] = test_file(test_number);


    % JOINT PLOT
    save_fig = 1;  
        display('*****************MAKE PLOT*****************')
        figure()
        plot(freq_a,flux_a)
        hold on, plot(freq_b,flux_b)

        legend('Fortran data','Matlab data')
        xlabel('x')
        ylabel('I')

        if save_fig == 1
            if xk0 == 0.5
                saveas(gcf,'figures/compare_Matlab_Fortran_more_freely_0005.png')
            else
                saveas(gcf,'figures/compare_Matlab_Fortran_more_freely_100.png')
            end
        end

    % close all
    % COMPARE THE DATA
        display('*****************COMPARE DATA*****************')
        % yes contains [xstart,xmuestart,rnew,xnew]
    %     N = 100
    %     selection_a = yes_a(:,N+1:N+10)
    %     selection_b = yes_b(:,N+1:N+10)
end
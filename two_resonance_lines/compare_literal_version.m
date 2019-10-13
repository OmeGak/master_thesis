function compare_literal_version()
    %% compare with Fortran (LITERALLY TRANSLATED VERSION)
    clc, clear all, close all

    save_fig = 1;
    xk0 = 100;

    % 1) FORTRAN DATA
        % mamaaaa contains data for xmuestart=sqrt(rand)
        % generated on 9-10-2019 with (pcyg_original.f90)

        display('FORTRAN DATA - -  - - - - - - - - - - - - - - - - - - - - - -- - - - - - - - - - - - - - - - - - - -')
        data_folder = '../introductory_exercises/P_Cygni_profile_UV_resonance/';

            if xk0 == 100
                file_name = [data_folder,'data/mamaaaaa']
            elseif xk0 == 0.5        
                file_name = [data_folder,'data/mamaaaaa_0005']
            end

            nphot = 10^5; alpha = 0;  beta = 1; test_case = 0; legend_1 = 'Sobolev scattering';     

            % maybe it is desired to add other data
                other_file_name = [];
                % other_file_name = [data_folder,'data/out_8_10_2']
                legend_2 = [];
                % legend_2 = 'isotropic scattering'
                name = [];
                name = 'data/simple_test.png';

        [freq_a,flux_a] = read_out(file_name,other_file_name,test_case,nphot,xk0,alpha,beta,legend_1,legend_2,name);
        iets =  zeros(1,length(freq_a));
        for k=1:length(freq_a)
            iets(k) = freq_a(length(freq_a)-k+1);
        end
        freq_a = iets;


    % 2) MATLAB DATA
        display('MATLAB DATA - - - - - - - - - - - - - - - - -  - - - - - - - - -  - - - - - - -  - - - - - - - -  ')

        nphot = 10^6
        alpha = 0
        beta = 1

        make_plot = 1;
        save = 0;
        all_radial = 0;

        [freq_b,flux_b,yes] = one_radial_line(nphot , xk0 , alpha , beta , make_plot , save , all_radial);    

    % 3) JOINT PLOT
        figure()
        plot(freq_a,flux_a)
        hold on, plot(freq_b,flux_b)

        legend('Fortran data','Matlab data')
        xlabel('x')
        ylabel('I')

        if save_fig == 1
            if xk0 == 0.5
                saveas(gcf,['figures/compare_Matlab_Fortran_literally_0005.png'])
            else
                saveas(gcf,['figures/compare_Matlab_Fortran_literally_',num2str(xk0),'.png'])
            end
        end 
    
end
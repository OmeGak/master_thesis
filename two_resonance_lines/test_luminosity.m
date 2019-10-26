function [freq, flux_two, number_scatterings , photon_path , yes , luminosity , rmax, backscatterings , dLdr ,g_radiation] = ...
            test_luminosity(test_number)
    %% do simple test with LUMINOSITY

    % get the data
    display('*******************************************')
    
    [freq, flux_two, number_scatterings , photon_path , yes , luminosity , rmax, backscatterings , dLdr ,g_radiation] ...
        = test_file(test_number);

    nphot = 10^5;   
    luminosity_star_surface = luminosity(1)

    % second part: make plot
    display('*******************************************')
    make_save = 1

    % PLOT LUMINOSITY
        figure()
        nrbins = 100; r_array = linspace(1,rmax,nrbins);
        loglog(r_array,luminosity)
        xlim([1,rmax])
        xlabel('r')
        ylabel('L(r)','Rotation',0)
        title('luminosity L(r)')

        figure()
        loglog(r_array(1:end-1),abs(dLdr))
        
        r_array_ = r_array(1:end-1);
        hold on, plot (r_array_,10^5*r_array_.^(-2),'--')
        xlim([1,rmax])
        xlabel('r')
        ylabel('L(r)','Rotation',0)
        title('dLdr(r)')
        legend('dLdr(r)','1/r^2')

        % save the figure
        test_situation = 0;
        if test_situation == 1
            title_fig = 'figures/luminosity_one_resonance_line_one_direction.png';
        elseif test_number == 16
            title_fig = 'figures/luminosity_multiple_resonance_line.png';
        else
            title_fig = 'figures/luminosity_one_resonance_line.png';
        end
        if make_save == 1
            saveas(gcf,title_fig)
        end

    % PLOT G_RAD
    %     figure()
    %     plot(r_array(1:end-1),g_radiation)
    %     xlim([1,rmax])
    %     xlabel('r')
    %     ylabel('dL(r)/dr','Rotation',0)
    %     title('dL/dr')
    %     
    %     % save the figure
    %     test_situation = 0;
    %     if test_situation == 1
    %         title_fig = 'figures/dLdr_one_resonance_line_one_direction.png';
    %     elseif test_number == 16
    %         title_fig = 'figures/dLdr_multiple_resonance_line.png';
    %     else
    %         title_fig = 'figures/dLdr_one_resonance_line.png';
    %     end
    %     if make_save == 1
    %         saveas(gcf,title_fig)
    %     end
end



%% do simple test with LUMINOSITY
clc, clear all, close all 

% get the data
display('*******************************************')
test_photon_path = 0;
test_luminosity = 1;

test_number = 21;
% test_number = 7;
test_number = 0;
% test_number = 16;   % two lines
[freq, flux_two, number_scatterings , photon_path , yes , luminosity , rmax, backscatterings , dLdr ,g_radiation] ...
    = test_file(test_number);

nphot = 10^5;

nrbins = 100;
r_array = linspace(1,rmax,nrbins);
correction_factor = number_scatterings*(1+0.25*(1+0.25))

% second part: make plot
display('*******************************************')
make_save = 1

% PLOT LUMINOSITY
    figure()
    %     subplot(1,2,1)
    plot(r_array,luminosity)
    %     hold on, plot(linspace(min(r_array),max(r_array),10),nphot*correction_factor*ones(1,10),'--')
    xlim([1,rmax])
    xlabel('r')
    ylabel('L(r)','Rotation',0)
    title('luminosity L(r)')

    %     subplot(1,2,2)
    %     loglog(r_array,luminosity)
    %     xlim([1,rmax])
    %     xlabel('r')
    %     ylabel('L(r)','Rotation',0)
    %     title('loglog representation of the same')

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

%% analyse the data manually
A = photon_path(:,18:20)
function plot_track_path(photon_path,track_path,b,number_paths,make_save,rmax)
    % only the photons that enter the Sobolev resonance zone are shown

    if track_path == 1
        display('track path of the photons')

        % A) plot photon path
        Nphot = number_paths;
        
        
        figure()
        subplot(3,1,1:2)
        c_map = jet(Nphot);
        rMAX = 0;
        rMIN = -1.2;
        
        for phot = 18:Nphot
            % specify a color
            a = c_map(phot,:);

            % initial shooting
            phot_loc_x = (photon_path(3,phot))*photon_path(2,phot);
            phot_loc_y = (photon_path(3,phot))*sqrt(1-photon_path(2,phot)^2);
            plot([1,phot_loc_x],[0,phot_loc_y] ,'.-','MarkerSize',20,'color',a)
            new_angle = acos(photon_path(3,phot));

            % other scattering events
            phot_number_scatterings = max(0,(max(find(photon_path(:,phot)))-4)/2+1)
            if phot_number_scatterings >= 2
                for k = 2:2:phot_number_scatterings
                    new_angle = new_angle + acos(photon_path(k+3,phot))
                    phot_loc_x = [phot_loc_x(end), cos(new_angle)*photon_path(k+2,phot)];
                    phot_loc_y = [phot_loc_y(end), sin(new_angle)*sqrt(1-photon_path(k+2,phot)^2)];
                    hold on, plot(phot_loc_x,phot_loc_y,'.-','MarkerSize',20,'color',a)
                    angle_x = cos(new_angle);
                    angle_y = sin(new_angle);
                end
                rMAX = max([rMAX,phot_loc_x]);
                rMIN = min([rMIN,phot_loc_x]);
            end

            % neem nog een eindstraal van R
            last_index = max(find(photon_path(:,phot)));
            if last_index > 1
                R = 2;
                phot_loc_x = [phot_loc_x(end), phot_loc_x(end) + R*photon_path(last_index,phot)];
                phot_loc_y = [phot_loc_y(end), phot_loc_y(end) + R*sign(photon_path(last_index,phot))*sqrt(1-photon_path(last_index,phot)^2)];
                hold on, plot(phot_loc_x,phot_loc_y,'--','MarkerSize',20,'color',a)
                rMAX = max([rMAX,phot_loc_x]);
                rMIN = min([rMIN,phot_loc_x]);
            end
            
        end
        x = linspace(-1,1,40);
        hold on, plot(x,sqrt(1-x.^2),'color','yellow','LineWidth',5)
        hold on, plot(x,-sqrt(1-x.^2),'color','yellow','LineWidth',5)
        
        R = 2;
        x = linspace(0,R,40);
        hold on, plot(x,sqrt(R^2-x.^2),'--','color','blue')
        hold on, plot(x,-sqrt(R^2-x.^2),'--','color','blue')
                
        R = rmax;
        x = linspace(0,R,40);
        hold on, plot(x,sqrt(R^2-x.^2),'--','color','blue')
        hold on, plot(x,-sqrt(R^2-x.^2),'--','color','blue')
        xlim([rMIN,rMAX])
        title('scattering history')
        
        
        % B) plot velocity profile
        subplot(3,1,3)
        r = linspace(1,rMAX,30);
        v = (1-b./r);
        plot(r,v);
        xlim([rMIN,rMAX]);
        title('velocity profile')
        xlabel('r')
        ylabel('v(r)','Rotation',0)
        
        
        if make_save == 1
            saveas(gcf,'figures/photon_path.png')
        end
        
    end
end
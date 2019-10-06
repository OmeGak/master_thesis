function plot_track_path(photon_path,track_path)
    if track_path == 1
        display('track path of the photons')

        Nphot = 20;
        figure(), hold on
        c_map = jet(Nphot);
        for phot = 1:Nphot
            % specify a color
            a = c_map(phot,:);

            % initial shooting
            phot_loc_x = [1 , 1+photon_path(3,phot)*photon_path(2,phot)];
            phot_loc_y = [1 , 1+photon_path(3,phot)*randi([-1,1])*sqrt(1-photon_path(2,phot)^2)];
            plot(phot_loc_x,phot_loc_y,'.-','MarkerSize',20,'color',a)

            % other scattering events
            phot_number_scatterings = (length(photon_path(:,phot))-4)/2 + 1;
            if phot_number_scatterings >= 2
                for k = 2:2:phot_number_scatterings
                    phot_loc_x = [phot_loc_x, phot_loc_x(end) + photon_path(3,phot)*photon_path(2,phot)];
                    phot_loc_y = [phot_loc_y, phot_loc_y(end) + photon_path(3,phot)*randi([-1,1])*sqrt(1-photon_path(2,phot)^2)];
                end
                plot(phot_loc_x,phot_loc_y,'.-','MarkerSize',20,'color',a)
            end

            % neem nog een eindstraal van 1
            phot_loc_x = [phot_loc_x(end), phot_loc_x(end) + photon_path(end,phot)];
            phot_loc_y = [phot_loc_y(end), phot_loc_y(end) + sign(photon_path(end,phot))*sqrt(1-photon_path(end,phot)^2)];
            plot(phot_loc_x,phot_loc_y,'--','MarkerSize',20,'color',a)
        end
        x = linspace(-1,1,20);
        hold on, plot(x,1+sqrt(1-x.^2),'color','yellow','LineWidth',4)
        hold on, plot(x,1-sqrt(1-x.^2),'color','yellow','LineWidth',4)
    end
end
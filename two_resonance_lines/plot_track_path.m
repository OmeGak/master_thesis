function plot_track_path(photon_path,track_path,b,number_paths,make_save,rmax)
    % only the photons that enter the Sobolev resonance zone are shown

    if track_path == 1
        %% A) plot photon path
        Nphot = number_paths;
        
        figure()
        subplot(3,1,1:2)
        c_map = jet(Nphot);
        rMAX = 5;
        rMIN = -5;
        
        for phot = 18:Nphot
                % specify a color
                a = c_map(phot,:);

                phot_number_scatterings = find(photon_path(1:end-1,phot));
                phot_number_scatterings = (max(phot_number_scatterings)-2)/3

%                 display('----')
%                 display(phot)
%                 display(phot_number_scatterings)

                % initial shooting
                phot_loc_x = 1;
                phot_loc_y = 0;
                old_radius = 1;

                % other scattering events
                if phot_number_scatterings >= 1
                    for k = 0:phot_number_scatterings-1

                        new_angle = acos(photon_path(2*k+2,phot));
                        new_angle_y_sign = sign(photon_path(2*k+2,phot));
                        new_radius = photon_path(2*k+3,phot);

                        syms phi
                        new_angle = vpasolve(sin(new_angle-phi)/old_radius - sin(pi-new_angle)/new_radius, phi);
                        if length(new_angle) == 0
                            new_angle = acos(photon_path(2*k+2,phot));
                        end

                        phot_loc_x = [phot_loc_x(end), cos(new_angle)*new_radius];
                        phot_loc_y = [phot_loc_y(end), new_angle_y_sign*sin(new_angle)*new_radius];
                        hold on, plot(phot_loc_x,phot_loc_y,'.-','MarkerSize',20,'color',a)

                        old_radius = new_radius;

                        rMAX = max([rMAX,phot_loc_x]);
                        rMIN = min([rMIN,phot_loc_x]);
                    end
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
                
        % end the loop over the photons
        end
        
        
        % make schematical picture of star
        x = linspace(-1,1,40);
        hold on, plot(x,sqrt(1-x.^2),'color','yellow','LineWidth',5)
        hold on, plot(x,-sqrt(1-x.^2),'color','yellow','LineWidth',5)
        
        % make picture of a nice radius
        R = 2;
        x = linspace(-R,R,60);
        hold on, plot(x,sqrt(R^2-x.^2),'--','color','blue')
        hold on, plot(x,-sqrt(R^2-x.^2),'--','color','blue')
        
%         % make picture of outermost radius
%         R = rmax;
%         x = linspace(-R,R,600);
%         hold on, plot(x,sqrt(R^2-x.^2),'--','color','blue')
%         hold on, plot(x,-sqrt(R^2-x.^2),'--','color','blue')
        
        % perform some formatting
        rMIN = double(rMIN);
        rMAX = double(rMAX);
        xlim([rMIN,rMAX])
        title(['scattering history (',num2str(Nphot-18+1),' photons)'])
            
        %% B) plot velocity profile
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
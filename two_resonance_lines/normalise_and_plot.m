function flux = normalise_and_plot(...
        nphot,nchan,flux,xmin,xmax,vmin,vmax,make_plot,freq,save,resonance_x,all_radial,radial_release,xstart_Fortran) 
    xnorm = nphot/nchan;
    flux = flux/xnorm;

%     display(xmax)
    
    if make_plot == 1
        figure()    
        
        plot(freq,flux,'.-','MarkerSize',20)
        hold on, plot(xmin*ones(1,10),linspace(min(flux),max(flux),10),'--','LineWidth',1)
        hold on, plot(xmax*ones(1,10),linspace(min(flux),max(flux),10),'--','LineWidth',1)
         
        for a = 1:length(resonance_x)
            hold on, plot(resonance_x(a)*ones(1,10),linspace(min(flux),max(flux),10),'--','LineWidth',2)
            hold on, plot((resonance_x(a)+vmax)*ones(1,10),linspace(min(flux),max(flux),10),'--','LineWidth',1)
            hold on, plot((resonance_x(a)+vmin)*ones(1,10),linspace(min(flux),max(flux),10),'--','LineWidth',1)
            patch([resonance_x(a)+vmin , resonance_x(a)+vmax, resonance_x(a)+vmax ,resonance_x(a)+vmin],...
                [min(flux),min(flux),max(flux),max(flux)],'r','FaceColor','r','FaceAlpha',.2,'EdgeAlpha',.2)
        end
        
        grid on        
        if all_radial == 1
            title('only radially streaming photons')
        elseif radial_release == 1
            title('radial release (xmuestart = 1)')
        end
        
        xlim([xmin,xmax])
        ylim([min(flux),max(flux)])
        
        xlabel('^{v}/_{v_{\infty}}','FontSize',14)
        ylabel('^{I}/_{I_0}','Rotation',0,'FontSize',14)
        
        if save == 1
            saveas(gcf,'data/radial_one_line.png')
        end       
    end
    
    if xstart_Fortran == 1
        iets = flux;
        for k =1:length(flux)
            flux(k) = iets(length(flux)-k+1);
        end
    end
    
end
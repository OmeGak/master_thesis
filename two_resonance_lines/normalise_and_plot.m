function flux = normalise_and_plot(nphot,nchan,flux,xmin,xmax,vmin,vmax,make_plot,freq,save,resonance_x) 
    xnorm = nphot/nchan;
    flux = flux/xnorm;

    if make_plot == 1
        figure()    
        
        plot(freq,flux,'.-','MarkerSize',20)
        hold on, plot(vmin*ones(1,10),linspace(min(flux),max(flux),10),'--')
        hold on, plot(vmax*ones(1,10),linspace(min(flux),max(flux),10),'--')
        
        hold on, plot(max(resonance_x+vmax)*ones(1,10),linspace(min(flux),max(flux),10),'-','MarkerSize',20,'LineWidth',2)
        hold on, plot(min(resonance_x+vmin)*ones(1,10),linspace(min(flux),max(flux),10),'-','MarkerSize',20,'LineWidth',2)
         
        for a = 1:length(resonance_x)
            hold on, plot(resonance_x(a)*ones(1,10),linspace(min(flux),max(flux),10),'--','LineWidth',2)
        end
        
        grid on
        
        if save == 1
            saveas(gcf,'data/radial_one_line.png')
        end       
    end
end
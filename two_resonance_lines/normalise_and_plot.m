function flux = normalise_and_plot(nphot,nchan,flux,xmin,xmax,vmin,vmax,make_plot,freq,save,resonance_x) 
    xnorm = nphot/nchan;
    flux = flux/xnorm;

    if make_plot == 1
        figure()    
        
        plot(freq,flux,'.-','MarkerSize',20)
        hold on, plot(xmin*ones(1,10),linspace(min(flux),max(flux),10),'--','LineWidth',1)
        hold on, plot(xmax*ones(1,10),linspace(min(flux),max(flux),10),'--','LineWidth',1)
         
        for a = 1:length(resonance_x)
            hold on, plot(resonance_x(a)*ones(1,10),linspace(min(flux),max(flux),10),'--','LineWidth',2)
            hold on, plot((resonance_x(a)+vmax)*ones(1,10),linspace(min(flux),max(flux),10),'--','LineWidth',1)
            hold on, plot((resonance_x(a)+vmin)*ones(1,10),linspace(min(flux),max(flux),10),'--','LineWidth',1)
        end
        
        grid on
        
        if save == 1
            saveas(gcf,'data/radial_one_line.png')
        end       
    end
end
function flux = normalise_and_plot(nphot,nchan,nin,flux,xmax,make_plot,freq,save,resonance_x) 
    xnorm = nphot/nchan;
    flux = flux/xnorm;

    if make_plot == 1
        figure()    
        
        plot(freq,flux,'.-','MarkerSize',20)
        hold on, plot(-xmax*ones(1,10),linspace(min(flux),max(flux),10),'--')
        hold on, plot(xmax*ones(1,10),linspace(min(flux),max(flux),10),'--')
        
        hold on, plot(max(resonance_x-0.99*0.98)*ones(1,10),linspace(min(flux),max(flux),10),':')
        hold on, plot(min(resonance_x-1.01*0.01)*ones(1,10),linspace(min(flux),max(flux),10),':')
         
        for a = 1:length(resonance_x)
            x_a = resonance_x(a);
            hold on, plot(-x_a*ones(1,10),linspace(min(flux),max(flux),10),'--')
        end
        
        grid on
        
        if save == 1
            saveas(gcf,'data/radial_one_line.png')
        end       
    end
end
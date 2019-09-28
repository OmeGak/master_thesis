function flux = normalise_and_plot(nphot,nchan,nin,flux,xmax,make_plot,freq,save) 
    xnorm = nphot/nchan;
    flux = flux/xnorm;

    if make_plot == 1
        figure()
        
        freq_ = freq;
        for k = 1:length(freq)
            freq(k) = freq_(length(freq_)-k+1);
        end        
        
        plot(freq,flux,'.-','MarkerSize',20)
        hold on, plot(-xmax*ones(1,10),linspace(min(flux),max(flux),10),'.--')
        hold on, plot(xmax*ones(1,10),linspace(min(flux),max(flux),10),'.--')
        hold on, plot(0*ones(1,10),linspace(min(flux),max(flux),10),'.--')
        if save == 1
            saveas(gcf,'data/radial_one_line.png')
        end       
    end
end
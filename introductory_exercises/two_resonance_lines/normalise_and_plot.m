function normalise_and_plot(nphot,nchan,nin,flux,make_plot,freq,save)
    xnorm = nphot/nchan;
    back_scattered_percent = nin/nphot*100;
    flux = flux/xnorm;

    if make_plot == 1
        figure()
        plot(freq,flux)
        if save == 1
            saveas(gcf,'data/radial_one_line.png')
        end
    end
end
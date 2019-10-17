function last_scatter = secundary_resonance_possible(xstart,resonance_x,vmin,vmax,last_scatter)
        vmin_ = resonance_x + 0.99*vmin;
        vmax_ = resonance_x + 1.01*vmax;

        scattering_possible = 0;
        for k=1:length(resonance_x)
            if (xstart >= vmin_(k)) & (xstart <= vmax_(k))
                scattering_possible = scattering_possible + 1;
            end
        end
        if scattering_possible == 0
            last_scatter = 1;
        end
end
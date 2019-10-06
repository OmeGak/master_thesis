function [freq,flux,total_number_scatterings,photon_path] = multiple_lines(nphot,xk0,alpha,beta,make_plot,...
        resonance_x,resonance_tau,save,nbins,possibility_scattering,multiple_scatterings,...
        all_radial,radial_release,isotropic_scattering,Eddington_limb_darkening,plot_only_scattering,...
        random_number,make_display,track_path,number_paths,make_save)  
    
    % set initial problem parameters
    [nchan,vmin,vmax,deltax,freq,flux,b,xmin,xmax,rmax,...
            nin,nout,photon_path,nsc,expected_scattering_ratio,r_init] =  ...
                param_init(beta,nbins,resonance_x,nphot);       
            
    rng(random_number);
    
    display('_____________________________________')
     
    % loop over all photons
    for phot = 1:nphot  
%         if make_display == 1
%             display('___________HERE WE GO____________')
%         end
        phot_nsc = 0;

        [goto_end_of_loop,xstart] = create_well(xmin,xmax,vmin,vmax,resonance_x);
        
        if (goto_end_of_loop == 1) & (plot_only_scattering == 0)
            [nout,flux] = add_count_photon(xstart,nout,xmin,deltax,nchan,flux,make_display);
        end
        
        if (goto_end_of_loop == 0) & (possibility_scattering == 1)  
            
            [xmuestart, one_photon_path] = release_photon(xstart,radial_release,Eddington_limb_darkening);
            

            [xnew,r_new,nin,last_scatter,xmueou,phot_nsc,photon_path] = ...
                    make_scattering(xstart,xmuestart,r_init,beta,alpha,b,rmax,xk0,nin,...
                    resonance_x,resonance_tau,all_radial,isotropic_scattering,phot_nsc,...
                    photon_path,phot,0); 
            one_photon_path = [one_photon_path; r_new; xmueou];
            
%             display('first scatter')            
%             display(r_init)
%             display(r_new)
%             display(xmueou)
            
            % secundary scattering events
            while (last_scatter == 0) & (multiple_scatterings == 1)
                [xnew,r_new,nin,last_scatter,xmueou,phot_nsc,photon_path] = ...
                    make_scattering(xnew,xmueou,r_new,beta,alpha,b,rmax,xk0,nin,...
                    resonance_x,resonance_tau,all_radial,isotropic_scattering,phot_nsc,...
                    photon_path,phot,0); 
                if last_scatter == 0
                    one_photon_path = [one_photon_path; r_new; xmueou];
                end
                
%                 display('secundary scatter')
%                 display(r_new)
%                 display(xmueou)

            end
            
            [nout,flux] = add_count_photon(xnew,nout,xmin,deltax,nchan,flux,make_display);
        else
            one_photon_path = [xstart ; zeros(3,1)];
        end
        
        if length(one_photon_path) < size(photon_path,1)
            one_photon_path = [one_photon_path; zeros(size(photon_path,1) - length(one_photon_path),1)];
        elseif length(one_photon_path) > size(photon_path,1)
            photon_path = [photon_path; zeros(length(one_photon_path) - size(photon_path,1),size(photon_path,2))];
        end
        photon_path = [photon_path, one_photon_path]; 
        
        nsc = nsc + phot_nsc;
    end

    flux = normalise_and_plot(nphot,nchan,flux,xmin,xmax,vmin,vmax,make_plot,freq,save,resonance_x);
    plot_track_path(photon_path,track_path,b,number_paths,make_save,rmax);
    total_number_scatterings = nsc/nphot
end
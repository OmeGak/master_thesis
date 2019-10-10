function [freq,flux,total_number_scatterings,photon_path,yes] = multiple_lines(nphot,alpha,beta,make_plot,...
        resonance_x,resonance_tau,save,nbins,possibility_scattering,multiple_scatterings,...
        all_radial,radial_release,isotropic_scattering,Eddington_limb_darkening,plot_only_scattering,...
        random_number,make_display,track_path,number_paths,make_save,compare_Fortran,deterministic_sampling_x,xstart_Fortran)  
%     display('MULTIPLE_LINES______(START)')
    
    rng(random_number);
%     s = rng;
    
    % set initial problem parameters
    [nchan,vmin,vmax,deltax,freq,flux,b,xmin,xmax,rmax,...
            nin,nout,photon_path,nsc,expected_scattering_ratio,r_init] =  ...
                param_init(beta,nbins,resonance_x,nphot,compare_Fortran);       
            
    display('_____________________________________')
     
    yes = zeros(4,nphot);
    % loop over all photons
    for phot = 1:nphot  
        phot_nsc = 0;
        
        % select xstart
        [xstart,goto_end_of_loop,deterministic_sampling_x] = ...
            create_well(xmin,xmax,vmin,vmax,resonance_x,deterministic_sampling_x,nphot,xstart_Fortran,phot);
        
        % go to the end if needed for plotting
        if (plot_only_scattering == 0) & (goto_end_of_loop == 1)
            [nout,flux] = add_count_photon(xstart,xstart,nout,xmin,deltax,nchan,flux,r_init);
        end
        yes(1,phot) = xstart;
        
        
        % ALL SCATTERING EVENTS
        if (goto_end_of_loop == 0) & (possibility_scattering == 1)  
            % select angle (economy on photon numbers)
            [xmuestart, one_photon_path] = release_photon(xstart,radial_release,Eddington_limb_darkening);
            yes(2,phot) = xmuestart;
                    
            [xnew,r_new,nin,last_scatter,xmueou,phot_nsc,photon_path,forget_photon,yes] = ...
                make_scattering(xstart,xmuestart,r_init,beta,alpha,b,rmax,nin,...
                    resonance_x,resonance_tau,all_radial,isotropic_scattering,phot_nsc,...
                    photon_path,phot,0,vmin,vmax,xstart_Fortran,yes);
            one_photon_path = [one_photon_path; r_new; xmueou];
                            
            
            if length(xnew) > 0
                yes(4,phot) = xnew;
            end
            
%             % ________________________________________________________________________________________
%             % also check if resonance is possible!
%             vmin_ = resonance_x + 0.99*vmin;
%             vmax_ = resonance_x + 1.01*vmax;
%             
%             for k=1:length(vmin)
%                 if (xstart >= vmin_(k)) & (xstart <= vmax_(k))
%                     last_scatter = 1;
%                 else
% %                     display('SHOOT THE PHOTON')
%                 end
%             end
%             if xstart == []
%                 last_scatter = 1;
%             end
%             
%             % secundary scattering events
%             while (last_scatter == 0) & (multiple_scatterings == 1)
% %                 display('hallo (2) - - - - - - - - - - - - - - - ')
% %                 display(last_scatter)
%                          
%                 [xnew,r_new,nin,last_scatter,xmueou,phot_nsc,photon_path] = ...
%                     make_scattering(xnew,xmueou,r_new,beta,alpha,b,rmax,nin,...
%                         resonance_x,resonance_tau,all_radial,isotropic_scattering,phot_nsc,...
%                         photon_path,phot,last_scatter,vmin,vmax,xstart_Fortran,yes); 
%                 if last_scatter == 0
%                     one_photon_path = [one_photon_path; r_new; xmueou];
%                 end
%                 
%                 % also check if resonance is possible!
%                 vmin_ = resonance_x + 0.99*vmin;
%                 vmax_ = resonance_x + 1.01*vmax;
% 
%                 for k=1:length(vmin)
%                     if (xstart >= vmin_(k)) & (xstart <= vmax_(k))
%                         last_scatter = 1;
%                     end
%                 end        
%                 
%                 if xstart == []
%                     last_scatter = 1;
%                 end
%                 
%             end
%             % ____________________________________________________________________________________________
             
            
            if forget_photon == 0
                [nout,flux] = add_count_photon(xnew,xstart,nout,xmin,deltax,nchan,flux,r_new);
            end
        else
            one_photon_path = [xstart ; zeros(3,1)];
        end
        
        % create photon_path
            if length(one_photon_path) < size(photon_path,1)
                one_photon_path = [one_photon_path; zeros(size(photon_path,1) - length(one_photon_path),1)];
            elseif length(one_photon_path) > size(photon_path,1)
                photon_path = [photon_path; zeros(length(one_photon_path) - size(photon_path,1),size(photon_path,2))];
            end
            photon_path = [photon_path, one_photon_path]; 
        
        nsc = nsc + phot_nsc;
    end

    % make plots and figures
    flux = normalise_and_plot(nphot,nchan,flux,xmin,xmax,vmin,vmax,...
        make_plot,freq,save,resonance_x,all_radial,radial_release);
    
    if xstart_Fortran == 1
        iets = flux;
        for k =1:length(flux)
            flux(k) = iets(length(flux)-k+1);
        end
    end
    
    plot_track_path(photon_path,track_path,b,number_paths,make_save,rmax);
    total_number_scatterings = nsc/nphot
    total_number_backscatterings = nin/nphot
    
%     display('MULTIPLE_LINES_______(END)')
end
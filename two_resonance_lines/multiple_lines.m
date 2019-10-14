function [freq,flux,total_number_scatterings,photon_path,yes,luminosity,rmax]...
    = multiple_lines(nphot,alpha,beta,make_plot,...
        resonance_x,resonance_tau,save,nbins,nrbins,possibility_scattering,multiple_scatterings,...
        all_radial,radial_release,isotropic_scattering,Eddington_limb_darkening,plot_only_scattering,...
        random_number,track_path,number_paths,make_save,compare_Fortran,...
        deterministic_sampling_x,xstart_Fortran)  
    
    clc
    rng(random_number);
%     s = rng;
    
    % set initial problem parameters
    [nchan,vmin,vmax,deltax,freq,flux,b,xmin,xmax,rmax,rmin,...
            nin,nout,photon_path,nsc,r_init,~,luminosity] =  ...
                param_init(beta,nbins,nrbins,resonance_x,compare_Fortran);               
            
    display('_____________________________________')
     
    yes = zeros(4,nphot);
    % loop over all photons
    for phot = 1:nphot  
        phot_nsc = 0;
        forget_photon = 0;
        r_new = rmin;
        
        % select xstart
        [xstart,goto_end_of_loop,deterministic_sampling_x] = ...
            create_well(xmin,xmax,vmin,vmax,resonance_x,deterministic_sampling_x,nphot,xstart_Fortran,phot);
        [xmuestart, one_photon_path] = release_photon(xstart,radial_release,Eddington_limb_darkening);
                
        % ALL SCATTERING EVENTS
        if (goto_end_of_loop == 0) & (possibility_scattering == 1)                    
            [xnew,r_new,nin,last_scatter,xmueou,phot_nsc,photon_path,forget_photon,...
                x_selected,luminosity] = ...
                    make_scattering(xstart,xmuestart,r_init,beta,alpha,b,rmax,nin,...
                        resonance_x,resonance_tau,all_radial,isotropic_scattering,phot_nsc,...
                        photon_path,vmin,vmax,xstart_Fortran,luminosity,nrbins);
            one_photon_path = [one_photon_path; r_new; xmueou];
            
%             display('-------------')
%             display(phot)
%             display(r_new)
            
%             luminosity = update_luminosity(xmuestart , r_new , rmax , r_init , nrbins , luminosity);
            
            % ________________________________________________________________________________________
            % also check if resonance is possible!            
            
            
%             % secundary scattering events
%             while (last_scatter == 0) & (multiple_scatterings == 1)
% %                 display('************************* MULTIPLE SCATTERINGS *****************************')
%                 [last_scatter,index] = secundary_resonance_possible(xstart,x_selected,resonance_x,vmin,vmax,last_scatter);
%                 
%                 if last_scatter == 0
%                     dummy_resonance_x = [resonance_x(1:index-1),resonance_x(index+1:end)];
%                     dummy_resonance_tau = [resonance_tau(1:index-1),resonance_tau(index+1:end)];
% 
%                     [xnew,r_new,nin,last_scatter,xmueou,phot_nsc,photon_path,forget_photon,...
%                             x_selected,luminosity] = ...
%                                 make_scattering(xnew,xmueou,r_new,beta,alpha,b,rmax,nin,...
%                                     dummy_resonance_x,dummy_resonance_tau,all_radial,...
%                                     isotropic_scattering,phot_nsc,...
%                                     photon_path,vmin,vmax,xstart_Fortran,luminosity,nrbins); 
%                     if last_scatter == 0
%                         one_photon_path = [one_photon_path; r_new; xmueou];
%                     end
%                 end
%             end
%             % ____________________________________________________________________________________________
             
        else
            one_photon_path = [xstart ; zeros(3,1)];
            r_new = r_init;
            xmuestart = release_photon(xstart,radial_release,Eddington);
            xnew = xstart;
        end
        
        [nout,flux] = add_count_photon(xnew,xstart,nout,xmin,deltax,nchan,flux,r_new,plot_only_scattering,forget_photon);
        luminosity = update_luminosity(xmuestart , r_new , rmax , r_init , nrbins , luminosity);
        
        % update luminosity for photons after their last scattering event
        nsc = nsc + phot_nsc; 
        
        [photon_path] = adjust_one_photon_path(photon_path,one_photon_path);
    end

    % make plots and figures
    flux = normalise_and_plot(nphot,nchan,flux,xmin,xmax,vmin,vmax,...
        make_plot,freq,save,resonance_x,all_radial,radial_release,xstart_Fortran);
       
    plot_track_path(photon_path,track_path,b,number_paths,make_save,rmax);
    total_number_scatterings = nsc/nphot
    total_number_backscatterings = nin/nphot
    
end
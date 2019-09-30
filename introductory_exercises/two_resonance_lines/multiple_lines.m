function [freq, flux,total_number_scatterings,photon_path] = multiple_lines(nphot,xk0,alpha,beta,make_plot,...
        resonance_x,save,nbins,possibility_scattering,multiple_scatterings,...
        all_radial,radial_release,isotropic_scattering,Eddington_limb_darkening)  
    
    [nchan,vmax,vmin,deltax,freq,flux,b,xmax,rmax,nin,nout] = param_init(beta,nbins);
    expected_scattering_ratio = (max(resonance_x + 0.99*vmax)-min(resonance_x + 1.01*vmin))/(2*xmax)
    
    total_number_scatterings = 0;
    rng(10);
    
    photon_path = zeros(1,nphot);
    % loop over all photons
    for phot = 1:nphot
        r_init = 0;
                
        [goto_end_of_loop,xnew,xstart] = sample_xstart(xmax);          
        photon_path(1,phot) = xstart;
                 
        [goto_end_of_loop,xnew] = create_well(xstart,vmax,vmin,goto_end_of_loop,xnew,resonance_x);
        
%         if (goto_end_of_loop == 0) 
%             if radial_release == 1
%                 xmuestart = 1;
%             elseif Eddington_limb_darkening == 1
%                 xmuestart = Eddington_limb_darkening_distribution()
%             else
%                 xmuestart = sqrt(rand);
%             end        
%             photon_path(2,phot) = xmuestart;
%             
%             if (possibility_scattering == 1)
%                 last_scatter = 0;
%                 [xnew,r_new,nin,last_scatter,xmueou] = make_scattering_multiple_lines(xstart,xmuestart,beta,alpha,b,rmax,xk0,nin,resonance_x,r_init,all_radial,isotropic_scattering);       
%                 total_number_scatterings = total_number_scatterings + 1;
%                 photon_path(3,phot) = r_new;
%                 photon_path(4,phot) = xmueou;
% 
%                 k = 1;
%                 while (last_scatter == 0) & (multiple_scatterings == 1)
%                     [xnew,r_new,nin,last_scatter,xmueou] = make_scattering_multiple_lines(xstart,xmuestart,beta,alpha,b,rmax,xk0,nin,resonance_x,r_new,all_radial,isotropic_scattering);   
%                     total_number_scatterings = total_number_scatterings + 1;
%                     if last_scatter == 0
%                         photon_path(4+k,phot) = r_new;
%                         photon_path(4+k+1,phot) = xmueou;       
%                         k = k + 2;
%                     end
%                 end
%             end
%         end

        % tally the photons
        nout = nout + 1;
        ichan = floor((xnew+xmax)/deltax) + 1;
        
        if (ichan > length(flux)) | (ichan < 1)
%                 display('probleem met binning')
%                 display(xnew)
                xnew = xmax;
                ichan = floor((xmax-xnew)/deltax) + 1;
        end
        
        flux(ichan) = flux(ichan) +1;        
    end

    flux = normalise_and_plot(nphot,nchan,nin,flux,xmax,make_plot,freq,save,resonance_x);
    total_number_scatterings = total_number_scatterings/nphot 
end
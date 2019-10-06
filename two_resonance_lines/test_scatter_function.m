function test_scatter_function()
    K = 10^4;
    all_phot_x = zeros(1,K);

    isotropic_scattering = 1;
    
    xmuestart = 1;
    beta = 1;
    alpha = 0;
    b = 1;
    rmax = 10;
    xk0 = 100;
    nin = 0;
    resonance_x = 0;
    r_init = 1;
    all_radial = 0;
    nsc = 0;
    photon_path = zeros(1,K);
    xstart_coll = zeros(1,K);
    
    x_selected = 0;
    tau_selected = 100;
    
    nsc = 0;


    for k = 1:K
        phot = k;
        xstart = -0.8*rand;
        r = best_line(xmuestart,xstart,resonance_x,r_init,rmax,b,beta,nsc);
        [xnew,xmueou] = scatter(xstart,x_selected,tau_selected,xmuestart,r,b,xk0,beta,alpha,all_radial,nsc,isotropic_scattering,nin)  
        all_phot_x(k) = xnew;
        xstart_coll(k) = xstart;
    end

    figure()
    subplot(1,2,1)
    histogram(xstart_coll,'NumBins',100) 
    title('xstart')

    subplot(1,2,2)
    histogram(all_phot_x,'NumBins',100) 
    title('xnew')
end
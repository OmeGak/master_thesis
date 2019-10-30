make_fig = 0

a = 2*linspace(1,10,10)
b = 2*logspace(0,1,10)

if make_fig == 1
    figure()
    plot(a,b,'.-','MarkerSize',20)
end

% de geometrische spacing
dx = nthroot(10,9);
c = b(1)*(log(b)-log(b(1)))/log(dx) + 1

% test for binning
A = 4;
pos = floor((log(A)-log(b(1)))/log(dx)) + 1

%% aplied to problem
clc

    taumax = 10;
    mu = 1;

    nbins = 20;
    taumin = 10^(-2);
    tau_array = logspace(-2,log(taumax)/log(10),nbins);
    dx = nthroot(taumax/taumin,nbins);
    J_array = zeros(1,nbins);
    
    tau_old = taumax;
    tau_new = 0.4;
    
    index_min = min(floor((log(tau_old)-log(taumin))/log(dx)) , floor((log(tau_new)-log(taumin))/log(dx)) ) + 1;
    index_max = max(floor((log(tau_old)-log(taumin))/log(dx)) , floor((log(tau_new)-log(taumin))/log(dx)) ) + 1;
    J_array(index_min:index_max) = J_array(index_min:index_max) + sign(mu);
    
    % plot
    semilogy(tau_array,'.','MarkerSize',20)
    
    % display some things
    display(tau_array)
    display(index_min)
    display(index_max)


clc, clear all, close all

% calculate two (interacting) lines
% radial-streaming assumption, i.e. mu=1

make_plot = 1
save = 1

nphot = 10^4
xk0 = 100
alpha = 0
beta = 1

nchan = 100;

xmax = 1.1;
vmin = 0.01;

deltax = 2*xmax/nchan;
freq = zeros(1,nchan);
flux = zeros(1,nchan);
freq(1) = xmax-5*deltax;
for n=1:nchan
    freq(n) = freq(1)-(n-1)*deltax;
end

b = 1-vmin^(1/beta);
vmax = 0.98;
rmax = b/(1-vmax^(1/beta));

nin = 0;
nout = 0;

for phot = 1:nphot
    goto_end_of_loop_1 = 0;
    goto_end_of_loop_2 = 0;

    xstart = rand;
    xstart = xmax*xstart;

    % perform the magic
    xrnd = rand;
    if xrnd >= 0.5
        xstart = -xstart;
        xnew = xstart;
        goto_end_of_loop_1 = 1;
    end

    vmax1 = vmax*0.99;
    vmin1 = vmin*1.01;
    if (xstart >= vmax1) | (xstart <= vmin1)
        % no resonance possible
        xnew = xstart;
        goto_end_of_loop_2 = 1;
    end

    % here the scattering part begins
    if (goto_end_of_loop_1 == 0) & (goto_end_of_loop_2 == 0)

        xmuestart = 1;
        pstart = sqrt(1-xmuestart^2);

        r_anal = b/(1-xstart^(1/beta))
        r_anal = max(1,min(r_anal,rmax))
        % force r to be between 1 and rmax, otherwise this gives an error
        % that ichan > nchan

        func = @(r) sqrt(1-(pstart/r)^2)*(1-b/r)^beta - xstart;
        r = rtbis(func , 1 , rmax , 10^(-5))

        xmuein = 1;

        v = (1-b/r)^(beta);
        dvdr = b*beta/r^2*(1-b/r)^(beta-1);
        sigma = dvdr/(v/r)-1;
        tau = xk0/(r*v^(2-alpha)*(1+xmuein^2*sigma));

        if tau >= rand
            xmueou = xmueout(xk0,alpha,r,v,sigma);

            if rand >= 0.5
                xmueou = -xmueou;
                pcheck = sqrt(r^2*(1-xmueou^2));
                if pcheck <= 1
                    nin = nin +1;
                end
            end

            xnew = xstart + v*(xmueou-xmuein);

        else
            xnew = xstart;
        end    
    end

    % tally the photons
    nout = nout + 1;
    ichan = floor((xmax-xnew)/deltax)+1;
    flux(ichan) = flux(ichan) +1;

end

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
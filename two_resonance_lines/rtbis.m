function rtbis = rtbis(func,x1,x2,xacc)

    maxit = 40;    
    
    fmid = func(x2);
    f = func(x1);
    
    if (f*fmid >= 0)
        
        M = 1.3;
        r_array = linspace(x1,M*x2,200);
        f = func(r_array);
        figure()
        plot(r_array,f)
        hold on, plot(x2*ones(1,10),linspace(min(f),max(f),10))
        grid on
        xticks([1,x2,M*x2])
        xlabel('r')
        ylabel('func')
        xlim([1,M*x2])
        
        error('ma jungske toch')
        
        rtbis = [];
    end
    
    if (f < 0)
        rtbis = x1;
        dx = x2-x1;
    else
        rtbis = x2;
        dx = x1-x2;
    end
    
    nit = 0;
    while ((abs(dx) >= xacc) | ~(fmid == 0)) & (nit < maxit)
        dx = dx/2;
        xmid = rtbis+dx;
        fmid = func(xmid);
        if fmid <= 0
            rtbis = xmid;
        end
        nit = nit + 1;
    end
    
end

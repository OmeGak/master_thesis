function rtbis = rtbis(func,x1,x2,xacc)

    maxit = 40;
    
    fmid = func(x2);
    f = func(x1);
    if (f*fmid > 0)
        rtbis = [];
    end
    
    if (f < 0)
        rtbis = x1;
        dx = x2-x1;
    else
        rtbis = x2;
        dx = x1-x2
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
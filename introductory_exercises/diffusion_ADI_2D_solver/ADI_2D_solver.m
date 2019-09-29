function erad = ADI_2D_solver(nx,ny,tend,ntime)

    x_min = 0;
    x_max = 1;
    len = x_max - x_min;
    
    x_arr = linspace(x_min,x_max,nx)';
    y_arr = x_arr;

    Erad = zeros(nx,ny);
    dx = x_arr(2)-x_arr(1);
    dy = dx;

    cfl = 10;
    dt = cfl*dx^2;

    % initial condition
    for i= 1:ny
        erad(:,i) = exp(-20.*(x_arr-len*0.5).^2-20.*(y_arr(i)-len*0.5)^2.);
    end

    % boundary conditions
    erad(:,1) = 0;
    erad(1,:) = 0;
    erad(nx,:) = 0;
    erad(:,ny) = 0;

    % diffusion coefficient
    diff = 1;

    % time steps
    tend = dt*ntime;
    time = 0;

    erad_upd = erad;
    erad_init = erad;

    minmax = [min(erad),max(erad)];
    ran = [x_min,x_max]
    surf(erad)

    % the actual calculation
    alp = zeros(nx,1) + 0.5*diff*dt/dx^2;
    bet = zeros(ny,1) + 0.5*diff*dt/dx^2;

    for jj = 0 : 1000 
        time = time + dt;

        % solve for x
        for j = 1 : ny 
            
            % set up r: explicit calculation
            r = zeros(ny,1);
            
            if (j == 1)
                r = bet.*erad(:,j+1) + (1-2*bet).*erad(:,j);
                erad(:,j)
                size(r)
            elseif (j == ny)
                r = (1-2*bet).*erad(:,j) + bet.*erad(j,1);
            else
                r = bet.*erad(:,j-1) + (1-2*bet).*erad(:,j) + bet.*erad(:,j+1);
            end

            % implicit calculation of erad
            A = diag(1+2*alp);
            A = A + diag(-alp(1:end-1),-1);
            A = A + diag(alp(1:end-1),1);

            erad_upd(:,j) = A\r; 
        end 

        % solve for y
        for j = 1 : nx
            % set up r: explicit calculation
            r = zeros(nx,1);
            if (j == 1)
                r =  alp.*erad(:,j+1)+(1-2*alp).*erad(:,j);
            elseif (j == ny)
                r = (1-2*alp).*erad(:,j) + alp.*erad(j,1);
            else
                r = alp.*erad(:,j-1) + (1-2*alp).*erad(:,j) + alp.*erad(:,j+1);
            end

            % implicit calculation of erad
            A = diag(1+2*bet);
            A = A + diag(-bet(1:end-1),-1);
            A = A + diag(bet(1:end-1),1);

            erad(j,:) = A\r; 
        end     

        % boundary conditions
        erad(:,1) = erad_init(:,1);
        erad(1,:) = erad_init(1,:);
        erad(nx,:) = erad_init(nx,:);
        erad(:,ny) = erad_init(ny,:);

        % plot solution
        figure(1)
        surf(erad)

        if time >= tend
            break
        end

end



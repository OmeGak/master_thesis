function [erad, erad_ana , error, error_col] = implicit_1D_solver(imp,tend,nx,cfl,make_plot,init_cond_num)
% solve DIFFUSION EQUATION with INITIAL CONDITON

    % initial condition
    xmin = 0;
    xmax = 1;
    
    x_arr = linspace(xmin,xmax,nx)';
    len = xmax - xmin;
    dx = x_arr(2) - x_arr(1);
 
    % choose your initial condition
    if init_cond_num == 1
        erad = sin(pi.*x_arr/len);
    elseif init_cond_num == 2
        erad = x_arr.*(1-x_arr);
    end
    
    % @ boundaries
    erad(1,1) = 0;
    erad(nx,1) = 0;

    % for logging purposes
    erad_init = erad;

    % constants and parameters
    diff = 1;
    dt = 0.5*cfl*dx^2/diff;
    nt = ceil(tend/dt)
    
    alp = zeros(nx,1) + diff*dt/dx^2;
    time = 0;

    % initialize error collection structure
    error_col = zeros(nt,1);
    
    amount_plot = 0;
    % actual calculation
    for j = 0 : nt
        
        time = time + dt;
        
        if (imp == 1)   % implicit calculation
            A = diag(1+2*alp);
            A = A + diag(-alp(1:end-1) , -1);
            A = A + diag(-alp(1:end-1) , 1);
            erad = A\erad; 
        else            % explicit computation
            for index = 2 : nx-2 
                erad(index) = (1 -2*alp(index))*erad(index) + alp(index)*(erad(index+1) + erad(index-1) );
            end
        end

        % update boundary conditions
        erad(1) = 0;
        erad(nx) = 0;

        % construct analytic solution for comparison (compute error)
        if init_cond_num == 1
            erad_ana = sin(pi*x_arr/len)*exp(-diff*pi^2*time/len^2);
        elseif init_cond_num == 2
            erad_ana = x_arr.*(1-x_arr)*exp(-diff*time/len^2);
            % wat is hier juist?
            erad_ana = 0;
        end
            
        
        % make plot
        if (make_plot == 1) && (rem(j,100) == 0)
            
            amount_plot = amount_plot + 1;
            
            figure(1), hold on
            
            plot(x_arr,erad_init,'--')
            
            plot(x_arr,erad)
            
            plot(x_arr,erad_ana)
            
            hold off
            title(['solution at ',num2str(time)])
        end
        error_col(j+1) = max(abs(erad - erad_ana));
        
    end
    
    amount_plot
    error = max(abs(erad - erad_ana));
    
    % end of the function
end
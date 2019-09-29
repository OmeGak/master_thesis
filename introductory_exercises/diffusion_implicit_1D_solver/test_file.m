clc, clear, close all

% implicit computation or not
imp = 1;
make_plot = 1;

% simulation parameters
tend = 1;
nx = 100;

% CFL number
cfl = 0.5;

init_cond_num = 2; 

[sol , exact, error , error_col] = implicit_1D_solver(imp,tend,nx,cfl,make_plot,init_cond_num);
error

% how does the error behave over time?
% zie ook figuur 2.4 uit Morton en Mayers
figure()
plot(linspace(0,tend,length(error_col)) , log(error_col)/log(10))
ylabel('log_{10}(error)')
xlabel('t_n')


%% Convergence properties
    % vergelijk oplossingen op een bepaald tijdstip (hier nt stappen)
    % first order accuracy with respect to time is expected
clc, clear, close all   

% implicit computation or not
imp = 1
make_plot = 0;

% simulation parameters
tend = 0.1;

% CFL number
cfl = 0.5;

nx_col = 50:50:200
for k = 1:length(nx_col)
    nx = nx_col(k);
    dx = 1/nx;
    diff = 1;
    dt = 0.5*cfl*dx^2/diff;
    
    % solve the equation
    init_cond_num = 1;
    [sol , exact, err, error_col] = implicit_1D_solver(imp,tend,nx,cfl,make_plot,init_cond_num);
    
    % collect data
    dt_col(k) = dt;
    error(k) = err;
end

figure()
loglog(nx_col,error,'.--')
hold on, loglog(nx_col,nx_col.^(-1),'-')

title('convergence')
ylabel('log_{10}(error)')
xlabel('number of grid points')
legend('experimental','N ^{0.5}')

make_save = 1
if make_save == 1
    saveas(gcf,'data/convergence.png')
end
file_name = 'data/out'
other_file_name = [];
% other_file_name = 'data/out_8_10_2'

test_case = 0;

nphot = 10^5
xk0 = 100
alpha = 0
beta = 1

legend_1 = 'Sobolev scattering'
legend_2 = []
% legend_2 = 'isotropic scattering'

name = []
name = 'data/xmueout_distribution.png'

read_out(file_name,other_file_name,test_case,nphot,xk0,alpha,beta,legend_1,legend_2,name)

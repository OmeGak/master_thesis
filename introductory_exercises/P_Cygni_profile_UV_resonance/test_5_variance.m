clc, clear all, close all

save_profile = 1;
make_plot = 1

variance_collection = zeros(3,3);
variance_collection(1,:) = 1:3

for k = 2:3
    variance_collection(2:3,k) = compare_variance(k,save_profile)'
end

variance_collection(1,1) = log(50)/log(10);
variance_collection(2:3,1) = compare_variance(12,save_profile)'

if make_plot == 1
    figure()
    b = 1;
    loglog(10.^variance_collection(1,b:end),variance_collection(2,b:end),'*--')
    hold on, loglog(10.^variance_collection(1,b:end),variance_collection(3,b:end),'*--')
    legend('random','det')
    xlabel('number of photons')
    ylabel('variance')
    
    saveas(gcf,'data/variance_reduction_test.png')
end
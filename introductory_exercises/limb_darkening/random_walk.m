clc, clear all, close all
               
save = 1

opacity_collection = 2.^(-4:4);
tau_collection = 1./opacity_collection;
N_collection = zeros(1,length(opacity_collection));

L = 10;

for k=1:length(opacity_collection)
    opacity = opacity_collection(k);
    l = 1/opacity;
        
    x = 0;

    N = 0;
    while abs(x) < L
        dx = l*(2*randi([0 1]) - 1);
        x = x + dx;
        N = N + 1;
    end

    N_collection(k) = N;
end

N_collection

figure()
loglog(opacity_collection,N_collection,'*--')
hold on, loglog(opacity_collection,(L*opacity_collection).^2)
xlabel('opacity \tau')
ylabel('N','Rotation',0)

legend('experimental', '\tau^2','Location','SouthEast')

if save == 1
    saveas(gcf,'data/diff_N_vs_opacity.png')
end

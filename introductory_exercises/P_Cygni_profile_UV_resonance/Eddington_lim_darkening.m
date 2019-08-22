close all
save = 1

% data from Christensen, 2015 
data = [ 0, 1, 
     .45103, .944; 
     .64350, .898; 
     .79540, .842; 
     .92730, .788;
     1.04720, .750; 
     1.15928, .670; 
     1.26610, .602; 
     1.36944, .522;  
     1.47063, 0.45]
 
figure()
subplot(1,2,1)
plot(data(:,1),data(:,2))
 
theta = linspace(0,pi/2,10)
I = 2/5+3/5*cos(theta)
hold on, plot(theta,I)
 
legend('experimental','theory')

xlabel('\theta')
ylabel('I(\theta)/I(0)','Rotation',0) 
 
 
subplot(1,2,2)
plot(cos(data(:,1)),data(:,2))

theta = linspace(0,pi/2,10)
I = 2/5+3/5*cos(theta)
hold on, plot(cos(theta),I)
 
legend('experimental','theory')
 
xlabel('\mu')
ylabel('I(\mu)/I(0)','Rotation',0) 

if save == 1
    saveas(gcf,'Eddington_limb_darkening.png')
end
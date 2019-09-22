function read_out(file_name,other_file_name,test_case,nphot,xk0,alpha,beta)
    % file_name:            name of file of data
    % other_file_name:      name of file containing data used for comparing
    % test_case:            see if-statements below

    % reads the output from the Fortran computations
    close all

    fileID = fopen(file_name,'r')
    formatSpec = '%f %f';
    sizeA = [2 Inf];
    A = fscanf(fileID,formatSpec,sizeA); 
    
    figure()
    plot(A(1,:),A(2,:))
    if length(other_file_name) > 0
        fileID = fopen(other_file_name,'r')
        B = fscanf(fileID,formatSpec,sizeA) 
        hold on, plot(B(1,:),B(2,:));
        
        legend('new version','old version')
    end
    
    % do figure formatting
    xlabel('x')
    ylabel('flux','Rotation',0)
    set(gca,'fontsize',14)

    if test_case == 0
        name = ['data/npot',num2str(log(nphot)/log(10)),'xk0',num2str(xk0),'alpha',num2str(alpha),'beta',num2str(beta),'test0.png']
    elseif test_case == 1
        name = ['data/npot',num2str(log(nphot)/log(10)),'xk0',num2str(xk0),'alpha',num2str(alpha),'beta',num2str(beta),'test1.png']
    elseif test_case == 2
        name = ['data/npot',num2str(log(nphot)/log(10)),'xk0',num2str(xk0),'alpha',num2str(alpha),'beta',num2str(beta),'test2.png']
    elseif test_case == 3
        name = ['data/npot',num2str(log(nphot)/log(10)),'xk0',num2str(xk0),'alpha',num2str(alpha),'beta',num2str(beta),'test3.png']
    elseif test_case == 4
        name = ['data/npot',num2str(log(nphot)/log(10)),'xk0',num2str(xk0),'alpha',num2str(alpha),'beta',num2str(beta),'test4.png']
    elseif test_case == 10
        name = ['data/npot',num2str(log(nphot)/log(10)),'xk0',num2str(xk0),'alpha',num2str(alpha),'beta',num2str(beta),'test10.png']
    elseif test_case == 20
        name = ['data/npot',num2str(log(nphot)/log(10)),'xk0',num2str(xk0),'alpha',num2str(alpha),'beta',num2str(beta),'test20.png']
    elseif test_case == 11
        name = ['data/npot',num2str(log(nphot)/log(10)),'xk0',num2str(xk0),'alpha',num2str(alpha),'beta',num2str(beta),'test11.png']
    elseif test_case == 5
        name = 'data/test.png'
    end
    saveas(gcf,name)
end
    
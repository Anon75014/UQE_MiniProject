%This loop plots the mean, variance and error of main.m as a function of n
%and p
clear all;

%desired values of n
min_power = 2; %starts at n=100
max_power = 4; %ends at n=10000
number_eval_n = 50; %50 points between min and max value 
N = logspace(min_power, max_power, number_eval_n); %values linearly distributed on a log scale
N=round(N); %functions only accept rounded values

%desired values of p
number_eval_p = 3; %three values of p
P = zeros([1 number_eval_p]);
for i=1:number_eval_p
    P(1,i) = i+1 ; %p starts at 2
end

%matrixes for mean, variance and error
Mean = zeros([2 number_eval_n]);
Variance = zeros([number_eval_p number_eval_n]);
LeastSquareError = zeros([number_eval_p number_eval_n]);
LeaveOneOutError = zeros([number_eval_p number_eval_n]);

M = 4; %4 inputs
sampling = 'random'; %sampling type ('random' or 'hypercube')

%while loop on the n values
j=1;
while j<number_eval_n+1
    n=N(1,j); %input size

    [E,X] = experimental_design(n,sampling);
    
    %while loop on the p values
    k=1;
    while k<number_eval_p+1
        p=P(1,k); %maximum degree of polynomials allowed
        u=voltage(X); %voltage calculated from original variables samples

        [Z,Alpha,c] = regression_matrix(M,p,E,u);

        U = zeros([1 n]);
            for i=1:n
                U(1, i) = model_evaluation(c,M,E(:,i),Alpha);
            end

        [ELOO,eLOO,evar] = leave_one_error(n,sampling,Z,c,Alpha);
    
        %storing values for mean, variance and error as a function of p
        Mean(1,j) = c(1,1);
        Mean(2,j) = mean(u);
        c(1) = [];
        Variance(k,j) = abs(sum(c.^2)/(sum((u-mean(u)).^2)/n)-1);
        LeastSquareError(k,j) = evar;
        LeaveOneOutError(k,j) = eLOO;
        k=k+1;
    end
    
    j=j+1;
end

%-------Plotting section
figure(1)
loglog(N, LeaveOneOutError(1,:));
hold on
loglog(N, LeaveOneOutError(2,:));
loglog(N, LeaveOneOutError(3,:));
hold off
legend('p=2','p=3','p=4');
 xlabel('number of evaluations');
 ylabel('Leave-one-out error');
 
 
figure(2)
loglog(N, LeastSquareError(1,:));
hold on
loglog(N, LeastSquareError(2,:));
loglog(N, LeastSquareError(3,:));
hold off
legend('p=2','p=3','p=4');
 xlabel('number of evaluations');
 ylabel('Least Square error');
 
 figure(3)
loglog(N, Mean(1,:));
hold on
loglog(N, Mean(2,:));
hold off
legend('U','u');
 xlabel('number of evaluations');
 ylabel('Mean');
 
  figure(4)
loglog(N, Variance(1,:));
hold on
loglog(N, Variance(2,:));
loglog(N, Variance(3,:));
hold off
legend('p=2','p=3','p=4');
 xlabel('number of evaluations');
 ylabel('Variance(u)/Variance(U) -1');


%------Exporting results as a dat file
N=N';
LeaveOneOutError=LeaveOneOutError';
LeastSquareError=LeastSquareError';
Mean=Mean';
Variance=Variance';
Results = horzcat(N, LeaveOneOutError, LeastSquareError, Variance, Mean);
writematrix(Results,'Results.dat','Delimiter',' ')  


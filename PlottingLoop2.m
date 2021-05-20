%This loop plots the mean, variance and error of main.m as a function of n
%and p
clear all;

%desired value of n
n_exp=10000;

%desired values of p
number_eval_p = 20;
P = zeros([number_eval_p 1]);
for i=1:number_eval_p
    P(i,1) = i ; %p starts at 1
end

%matrixes for mean, variance and error
Mean = zeros([number_eval_p 1]);
Variance = zeros([number_eval_p 1]);

M = 4; %4 inputs
sampling = 'random'; %sampling type ('random' or 'hypercube')


    
%while loop on the p values
k=1;
while k<number_eval_p+1
     [E,X] = experimental_design(n_exp,sampling);
     p=P(k,1); %maximum degree of polynomials allowed
     u=voltage(X); %voltage calculated from original variables samples
    
     [Z,Alpha,c] = regression_matrix(M,p,E,u);

     n = 1000;
     [E,X] = validation_set(n,sampling);
     u = voltage(X);
     U = zeros([1 n]);
         for i=1:n
             U(1, i) = model_evaluation(c,M,E(:,i),Alpha);
         end
    
    %storing values for mean, variance and error as a function of p
    Mean(k,1) = abs(mean(U)-mean(u));
    c(1) = [];
    Variance(k,1) = abs((sum((U-mean(U)).^2)/n)/(sum((u-mean(u)).^2)/n)-1);
    k=k+1;
end



 figure(1)
loglog(P, Mean(:,1));
 xlabel('p');
 ylabel('Mean');
 
figure(2)
loglog(P, Variance(:,1));
 xlabel('p');
 ylabel('Variance');
 
figure(3)
histogram(U, 'Normalization', 'pdf', 'BinWidth',0.002);
hold on
histogram(u, 'Normalization', 'pdf', 'BinWidth',0.002);
hold off
xlabel('voltage (V)', 'interpreter','latex', 'FontSize', 12);
ylabel('PDF', 'interpreter','latex','FontSize', 12);
legend('U', 'u');

 
%------Exporting results as a dat file
Results = horzcat(P, Variance, Mean);
writematrix(Results,'MeanVariance.dat','Delimiter',' ') 
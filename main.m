clear all;

%-----Distributed unputs
M = 4; %number of distributed inputs (cell resistance, activity ratios and flow rate)

%------ Experimental design
%--inputs
n=1000; %input size
sampling = 'random'; %sampling type ('random' or 'hypercube')
%--outputs
%X: original variables samples (Mxn matrix)
%E: auxiliary variables samples uniformly distributed on [-1,1] (Mxn matrix)
[E,X] = experimental_design(n,sampling);

%------ Regression matrix
%--inputs
p=2; %maximum degree of polynomials allowed
u=voltage(X); %voltage calculated from original variables samples
%--outputs
%Z: regression matrix (nxP) where P=(M+p)!/M!p!
%Alpha: set of multi-indices that satisfy the requirement |α|≤p
%c: coordinates of the Legendre basis
[Z,Alpha,c] = regression_matrix(M,p,E,u);

%------ Evaluation of the PCE model
%--outputs
%U: voltage from PCE-evaluated model
U = zeros([1 n]);
for i=1:n
        U(1, i) = model_evaluation(c,M,E(:,i),Alpha);
end


%----- leave-one-out error
%--outputs
%ELOO,eLOO: leave-one-out error before or after divided by the variance of U
%evar: mean-squared error
[ELOO,eLOO,evar] = leave_one_error(n,sampling,Z,c,Alpha);


figure(1)
histogram(U, 'Normalization', 'pdf', 'BinWidth',0.002);
hold on
histogram(u, 'Normalization', 'pdf', 'BinWidth',0.002);
hold off
xlabel('voltage (V)', 'interpreter','latex', 'FontSize', 12);
ylabel('PDF', 'interpreter','latex','FontSize', 12);
legend('U', 'u');

%------Exporting results as a dat file
u=u';
U=U';
Results = horzcat(u, U);
writematrix(Results,'Uandup2.dat','Delimiter',' ')  


%% calculate the leaveoneerror of the model
%input
%val_n: size of validation set
%sampling: type of sampling between 'random' or 'LatinHypercube'
%Z: regression matrix of dimensions nxP
%c: vector containing the PCE coefficients
%Alpha: output of regression_matrix.m

%output
%ELOO,eLOO: leave-one-error before or after divided by the variance of U
%eLOO_mod: modified the error by Heuristic modification factors to avoid overfitting
%evar: mean-squared error

function [ELOO,eLOO,evar] = leave_one_error(n,sampling,Z,c,Alpha)
[val_E,val_X] = validation_set(n,sampling); % get the validation set

U_val = voltage(val_X); % get the experimental result of validation set
%U_val is a row vector of dimension 1xval_n
Y_val=zeros([1 n]);
for i=1:n
    Y_val(1,i) = model_evaluation(c,4,val_E(:,i),Alpha);% get the PCE result of validation set
end
% calculate the leave-one-rror
h = Z* pinv(Z'*Z) *Z';
ELOO = sum(((U_val-Y_val)./(ones(1,n)-diag(h)')).^2)/n; % calculate the leaveoneerror

eLOO = ELOO / sum((U_val-mean(U_val)).^2);
%eLOO_mod = eLOO * (1+trace(pinv(Z'*Z./val_n))/val_n)/(1-det(Z)/val_n); % modified the error by Heuristic modification factors to avoid overfitting

% mean-squared error
evar = sum((U_val-Y_val).^2) / sum((U_val-mean(U_val)).^2);


end

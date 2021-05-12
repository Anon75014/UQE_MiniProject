function [E,X] = validation_set(n,sampling)
%function which creates the validation set in a compact way
%Input Variables:
%n: sampling points of the validation set
%sampling: type of sampling between 'random' or 'LatinHypercube'
%Output Variables:
%E is a matrix of dimension 4xn containing auxiliary variables samples
%uniformly distributed on [-1,1];
%X is a matrix of dimension 4xn containing the original variables samples


if strcmp(sampling,'random') == 1
    [R_original,R_uniform] = input_sampling(n,'random','RCell');
    [GammaP_original,GammaP_uniform] = input_sampling(n,'random','GammaP');
    [GammaN_original,GammaN_uniform] = input_sampling(n,'random','GammaN');
    [Q_original,Q_uniform] = input_sampling(n,'random','Q');
else
    [R_original,R_uniform] = input_sampling(n,'LatinHypercube','RCell');
    [GammaP_original,GammaP_uniform] = input_sampling(n,'LatinHypercube','GammaP');
    [GammaN_original,GammaN_uniform] = input_sampling(n,'LatinHypercube','GammaN');
    [Q_original,Q_uniform] = input_sampling(n,'LatinHypercube','Q');
end

E=vertcat(R_uniform',GammaP_uniform',GammaN_uniform',Q_uniform');
X=vertcat(R_original',GammaP_original',GammaN_original',Q_original');
end

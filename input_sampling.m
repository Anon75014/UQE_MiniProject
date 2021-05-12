%% Input sampling and isoprobability transformation
% by Jian TANG @ Empa & ETHz
% Input parameters:
% sampling_points: size of sample (int)
% sampling_method: 'random' or 'LatinHypercube' (str)
% sampling_feature: 'RCell'or 'GammaP'or 'GammaN'or 'Q' (str)


% Output:
% inp_sam: samples after isoprobability transformation
% inp_sam_bef: samples before isoprobability transformation ~ U[-1,1]

function [inp_sam,inp_sam_bef] = input_sampling(sampling_points,sampling_method,sampling_feature)

	%---Cell resistance (normal distribution)
    mR=0.380; %mean (Ohms)
    sR=0.100; %var (Ohms)

    %---Activity ratios (lognormal distribution)
    muGammap=1; %mean
    sigmaGammap=0.5; %var

    muGamman=1; %mean
    sigmaGamman=0.6; %var

    %---Flow rate (normal distribution)
    mQ=21e-6/60; %mean (conversion mL/min to m^3/s)
    sQ=3e-6/60; %var (conversion mL/min to m^3/s)
    
    % transform the sampling into uniform distribution between [-1,1]
    if strcmp(sampling_method,'random')
        inp_sam_bef = rand([sampling_points 1])*2.0-1.0; % random sampling
    elseif strcmp(sampling_method,'LatinHypercube')
        inp_sam_bef = lhsdesign(sampling_points,1)*2.0-1.0; % Latin Hypercube Sampling
    else
        fprintf('Wrong input sampling method! Check your input parameters!');
    end

    % transform the sampling into uniform distribution between [ai,bi]
    if strcmp(sampling_feature,'RCell')
        inp_sam = inp_sam_bef * sR + mR;  
    elseif strcmp(sampling_feature,'GammaP')
        inp_sam = inp_sam_bef * sigmaGammap + muGammap; 
    elseif strcmp(sampling_feature,'GammaN')
        inp_sam = inp_sam_bef * sigmaGamman + muGamman; 
    elseif strcmp(sampling_feature,'Q')
        inp_sam = inp_sam_bef * sQ + mQ; 
    else
        fprintf('Wrong input sampling feature! Check your input parameters!');
    end


end

function [f,p,emptyNullModel,hasIntercept] = ftest(model)
%FTEST Summary of this function goes here
% Test if non-linear part of the model function is zero. Do one of
% the following:
% (1) If full model has an intercept and number of estimated coefficients
%     is > 1 then test full model against the intercept only model.  
% (2) Otherwise, test full model against a zero model.

% Variable emptyNullModel is:
%  -  true if our null model is the zero model. 
%  - false if our null model is the intercept only model.            

% (1) Inspect unweighted Jacobian and figure out if there is an
% intercept (i.e., if if Junw_r has a constant column).
[~,Junw_r] = create_J_r(model);
Jmin = min(Junw_r,[],1);
Jmax = max(Junw_r,[],1);
hasIntercept = any( abs(Jmax-Jmin) <= sqrt(eps(class(Junw_r))) * (abs(Jmax) + abs(Jmin)) ); 
if hasIntercept &&  (model.NumEstimatedCoefficients > 1)
    % (2) Compare full model vs. intercept only model.
    emptyNullModel = false;
    nobs = model.NumObservations;
    ssr = max(model.SST - model.SSE,0);
    dfr = model.NumEstimatedCoefficients - 1;
    dfe = nobs - 1 - dfr;
    f = (ssr./dfr) / (model.SSE/dfe);
    p = fcdf(1./f,dfe,dfr); % upper tail
else
    % (2) Compare full model vs. zero model.
    emptyNullModel = true;
    ssr = max(model.SST0 - model.SSE,0);
    dfr = model.NumEstimatedCoefficients;
    dfe = model.NumObservations - model.NumEstimatedCoefficients;
    f = (ssr./dfr) / (model.SSE/dfe);
    p = fcdf(1./f,dfe,dfr); % upper tail
end

end 


% --------------------------------------------------------------------
function [J_r,Junw_r] = create_J_r(model)
    subset = model.ObservationInfo.Subset;
    design = model.Variables.X1;
    J_r = jacobian(model,design(subset,:));
    if nargout>=2
        Junw_r = J_r; % unweighted version of Jacobian
    end
    w = model.ObservationInfo.Weights(subset,:);
    if ~all(w==1)
        J_r = bsxfun(@times, sqrt(w), J_r);
    end
end

% --------------------------------------------------------------------
function J = jacobian(model,X)
% Approximate the Jacobian at Formula.ModelFun(beta,X).
beta = model.Coefficients.Estimate;
dbeta = eps(max(abs(beta),1)).^(1/3);
J = zeros(size(X,1),model.NumCoefficients);
for i = 1:model.NumCoefficients
   h = zeros(size(beta)); h(i) = dbeta(i);
   ypredplus = model.Formula.ModelFun(beta+h, X);
   ypredminus = model.Formula.ModelFun(beta-h, X);
   J(:,i) = (ypredplus - ypredminus) / (2*h(i));
end

end
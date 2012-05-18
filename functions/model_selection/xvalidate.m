function [xv_mean, xv_std] = xvalidate(estimator, prcdata, filts, etas_)
% [xv_mean, xv_std] = xvalidate(estimator, prcdata, filters, etas)
% generates the cross-validation results for given estimation parameters.
%
% Inputs
% ======
% * estimator: estimator object for evaluating the estimate (via
% estimator.evaluate function) and calculating the error (via
% estimator.error_func).
% * prcdata: data constructed by make_PRC_data function
% * filters: filters generated according to the cross-validation scheme.
% * etas: a vector containing the values of the estimation parameter.
% 
% Outputs
% =======
% * xv_mean: mean of cross-validation errors for all the filters.
% * xv_std: stdev of cross-valiadiot errors.
%
%
% Written by: Sungho Hong, CNS Unit, Okinawa Inst of Sci Tech
% Email: shhong@oist.jp
%

xvvals = xvalall(estimator, prcdata, filts, etas_);

xv_mean = mean(xvvals,2);
xv_std = std(xvvals,[],2);

end
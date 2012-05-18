function ic = info_crit(estimator, prcdata, etas)
% ic = info_crit(estimator, data, etas) calculates all the
% information criteria given the parameters etas. The implemented criteria
% are Akaike (aic), Bayesian (bic), and Residual (ric) information
% criterion.
%
% Inputs
% ======
% * estimator: estimator object for evaluating the estimate (via
% estimator.evaluate function) and calculating the error (via
% estimator.error_func).
% * prcdata: data constructed by make_PRC_data function
% * etas: a vector containing the values of the estimation parameter.
% 
% Outputs
% =======
% ic: a structure with fields, 'aic', 'bic', and 'ric', which correspond to
% the information criteria given estimation parameter. AIC and RIC include
% the known corrections for finite data size.
%
%
% Written by: Sungho Hong, CNS Unit, Okinawa Inst of Sci Tech
% Email: shhong@oist.jp
%


Netas = numel(etas);
ic = struct();
ic.aic = zeros(Netas,1);
ic.bic = zeros(Netas,1);
ic.ric = zeros(Netas,1);
N = size(prcdata.nstim,1);
for i=1:Netas
    eta = etas(i);
    thisprc = estimator.evaluate(prcdata, eta);
    rss = norm(prcdata.y-prcdata.nstim*thisprc)^2;
    k = estimator.dimK;
    ic.aic(i) = N*log(rss/N)+2*k + 2*k*(k+1)/(N-k-1);
    ic.bic(i) = N*log(rss/N)+k*log(N);
    ic.ric(i) = N*log(rss/(N-k))+ k + 4*(k+1)/(N-k-2);
end

end

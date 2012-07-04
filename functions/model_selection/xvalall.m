function xvvals = xvalall(estimator, prcdata, filts, etas_)
% xvvals = xvall(estimator, prcdata, filters, etas)
% returns the cross-validation results for given estimation parameters.
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
% * xvvals: (length of etas)x(number of filters) dimensional matrix where
% each column contains the cross-validation errors for the data selected
% by the corresponding filter.
%
%
% Written by: Sungho Hong, CNS Unit, Okinawa Inst of Sci Tech
% Email: shhong@oist.jp
%

Nfilts = size(filts,2);
Netas = numel(etas_);
etas = etas_;
% disp('Randomizing the data....');
% randomized_ind = randperm(size(prcdata.nstim,1));
% prcdata.nstim = prcdata.nstim(randomized_ind,:);
% prcdata.y = prcdata.y(randomized_ind);
% prcdata.isis = prcdata.isis(randomized_ind);

xvvals = zeros(Netas,Nfilts);

disp(['Total number of (train, test) pairs = ' num2str(Nfilts) '.']);
disp(['Each train set contains ' num2str(sum(~filts(:,1)))...
      ' isis out of ' num2str(size(prcdata.nstim,1)) '.']);

h = waitbar(0,'Test is starting...');
for j=1:Nfilts
    filt = filts(:,j);
    train_prcdata = filter_prcdata(prcdata, ~filt);
    test_prcdata = filter_prcdata(prcdata, filt);
    estimator.reset();
    for i=1:Netas
        eta = etas(i);
        thisprc = estimator.evaluate(train_prcdata, eta);
        xvvals(i,j) = estimator.error_func(thisprc, test_prcdata);
    end
    waitbar(j/Nfilts,h,sprintf('Evaluated XV for the test set %d/%d.',j,Nfilts));
end
waitbar(1,h,'Done.');
close(h);

end
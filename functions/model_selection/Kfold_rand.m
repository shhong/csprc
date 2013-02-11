function filts = Kfold_rand(N_,k,kp_)
% filters = Kfold_rand(N, k, kp) works exactly the same as Kfold but the
% rows are randomized.
%
% Inputs
% ======
% * N: the size of data or the data structure containing its size as a
% field 'N'.
% * k: number of folds
% * kp: number of filters in case that you want to use only some of the
% filters for cross-validation. If you omit this, kp = k.
% 
% Outputs
% =======
% * filters: (Nxkp) matrix each of which column contains only falses except
% for [N/k] trues.
%
%
% Written by: Sungho Hong, CNS Unit, Okinawa Inst of Sci Tech
% Email: shhong@oist.jp
%

if isstruct(N_), N = size(N_.nstim,1); else N = N_; end
Nlines = floor(N/k);
filts = false(N,k);

if (nargin<3), kp = k; else kp = kp_; end

for i=1:kp
    ind = ((i-1)*Nlines+1):(i*Nlines);
    filts(ind,i) = true;
end
randind = randperm(N);
filts = filts(randind,:);
end

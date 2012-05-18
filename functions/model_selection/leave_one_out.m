function filts = leave_one_out(N_, k)
% filters = leave_one_out(N, k) returns the k selection filters given data
% size N for the leave-one-out cross-validation scheme (see Hastie et al.,
% Elements of Statistical Learning, 2009).
%
% Inputs
% ======
% * N: the size of data or the data structure containing its size as a
% field 'N'.
% * k: number of filters in case that you want to use only some of the
% filters for cross-validation. If you omit this, k = N.
% 
% Outputs
% =======
% * filters: (Nxk) matrix each of which column contains only falses except
% for one true.
%
%
% Written by: Sungho Hong, CNS Unit, Okinawa Inst of Sci Tech
% Email: shhong@oist.jp
%

if isstruct(N_), N = size(N_.nstim,1); else N = N_; end
filts = logical(eye(N,'int8'));

if (nargin>1)
    rind = randperm(N);
    filts = filts(:,rind(1:k));
end

end
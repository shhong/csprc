function new_data = subselect_data(data,N)
% new_data = subselect_data(data, N) returns the subselected data with
% given number of ISIs or ISI indices.
%
% Inputs
% ======
% * data: the original data
% * N: If N is a number, the function will randomly select N distinct ISIs
% and return the corresponding data. If N is a vector of indices, the data
% corresponding to those indices will be chosen.
%
% Outputs
% =======
% * new_data: subselected data
%
%
% Written by: Sungho Hong, CNS Unit, Okinawa Inst of Sci Tech
% Email: shhong@oist.jp
%

new_data = data;

if length(N)>1
    ind = N;
    new_data.N = numel(ind);
else
    ind = randperm(data.N);
    ind = ind(1:N);
    new_data.N = N;
end

new_data.y = data.y(ind,:);
new_data.nstim = data.nstim(ind,:);
new_data.ntrace = data.ntrace(ind,:);
new_data.isis = data.isis(ind,:);

end
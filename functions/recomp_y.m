function new_data = recomp_y(data)
% new_data = recomp_y(data) returns new_data where "y" is recomputed again.
%
% Inputs
% ======
% * data: the original data
%
% Outputs
% =======
% * new_data: the same data except y is recomputed by recomputing the mean 
% isi.
%
% Written by: Sungho Hong, CNS Unit, Okinawa Inst of Sci Tech
% Email: shhong@oist.jp
%

new_data = data;
new_data.y = (mean(data.isis)./data.isis - 1);

end
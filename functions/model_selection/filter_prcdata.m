function filtered_data = filter_prcdata(data, filt_ind)
% filtered_data = filter_prcdata(data, filter) returns the selected part
% of the data filtered by filter. This is used by xvalall function.
%
% Written by: Sungho Hong, CNS Unit, Okinawa Inst of Sci Tech
% Email: shhong@oist.jp
%

filtered_data = data;
filtered_data.nstim = data.nstim(filt_ind,:);
filtered_data.y = data.y(filt_ind);
filtered_data.isis = data.isis(filt_ind);

end

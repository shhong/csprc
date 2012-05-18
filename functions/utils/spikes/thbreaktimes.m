function spiketime = thbreaktimes(trace, threshold);
% spiketime = thbreaktimes(trace, threshold) returns the spiketimes by
% detecting the upward breaking of the threshold in the voltage trace.
%
% Inputs
% ======
% * trace: voltage trace.
% * threshold: voltage threshold for detecting spikes.
% 
% Outputs
% =======
% * spiketime: a vector containing the indices for found peak locations.
%
%
% Written by: Sungho Hong, CNS Unit, Okinawa Inst of Sci Tech
% Email: shhong@oist.jp
%

spiketime   = find(trace(1:end-1)<threshold & trace(2:end)>=threshold);

end

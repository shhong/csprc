function spiketime = peaktimes(trace, threshold)
% spiketime = peaktimes(trace, threshold) returns the spiketimes by
% detecting the peaks in the voltage trace.
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

breakup   = find(trace(1:end-1)<threshold & trace(2:end)>=threshold);
breakdown = find(trace(1:end-1)>=threshold & trace(2:end)<threshold);

if breakdown(1)<breakup(1)
  breakdown = breakdown(2:end);
end

if breakdown(end)<breakup(end)
  breakup = breakup(1:end-1);
end

if numel(breakdown)~=numel(breakup)
  error('Threshold breakings upward and downward are mismatching. Something is wrong.')
end

spikesize = max(breakdown-breakup);
disp(['Max spike size = ' num2str(spikesize)])

spiketime = breakup;
Nspike = numel(spiketime);

for i=1:Nspike
  spike = trace(breakup(i):breakdown(i));
  [peak, peaktime] = max(spike);
  spiketime(i) = spiketime(i) + peaktime-1;
end

end

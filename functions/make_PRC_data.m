function PRCData = make_PRC_data(stimset, vset, dataParameter)
% PRCData = make_PRC_data(stimset, vset, dataParameters) returns PRCData
% structure that is ready for PRC estimation.
%
% Inputs
% ======
% * vset and stimset: _cells_ containing voltage traces and 
% corresponding stimuli. We use the cell for combining the data from
% multiple recordings from a neuron.
% * dataParameter: a _structure_ containing informations about
% experiments. In particular, it _should_ contain the fields
%    * 'mean' : mean of the stimuli
%    * 'std' : stdev of the stimuli
%    * 'srate' : the sampling rate in _Hz_, and
%    * 'L': the length of rescaled stimuli.
% 
%
% Outputs
% =======
% * PRCData: a structure contains all the information in dataParameter and
%   * N: total number of ISIs,
%   * L: length of each stimuli,
%   * nstim: stretched stimuli for the ISIs in an (NxL) matrix,
%   * y: change in instantaneous firing rate,
%   * ntrace: stretched voltage for the ISIs,
%   * isis: ISI sizes in ms,
%   * dt: mean ISI size divided by L.
%
%
% Written by: Sungho Hong, CNS Unit, Okinawa Inst of Sci Tech
% Email: shhong@oist.jp
%



PRCData = dataParameter;

Nseg = length(vset);
isis = [];

for i=1:Nseg
    v = vset{i};
    spiketime = peaktimes(v, -20);
    isis = [isis; diff(spiketime)];
end

y = (mean(isis) - isis)./isis;
N = length(y);
if ~isfield(PRCData, 'L')
    L = round(mean(isis));
    if mod(L,2)==0  % L should be always odd.
        L = L+1;
    end
    PRCData.L = L;
else
    L = PRCData.L;
end

D = L;
k = 1;
nstim = zeros(N,L);
ntrace = zeros(N,L);
tt = linspace(0,1,L);
for i=1:Nseg
    stim = (stimset{i} - mean(stimset{i}))/std(stimset{i});
    v = vset{i};
    spiketime = peaktimes(v, -20);
    nisi = length(spiketime)-1;
    for i=1:nisi
        scut = stim(spiketime(i):spiketime(i+1));
        vcut =    v(spiketime(i):spiketime(i+1));
        torig = linspace(0,1,numel(scut));
        nstim(k,:)  = stretch(scut, D);%, numel(scut)); %interp1(torig,scut,tt, 'pchip');
        ntrace(k,:) = stretch(vcut, D);%, numel(scut)); %interp1(torig,vcut,tt, 'pchip');
        k = k+1;
    end
end

isis = isis/PRCData.srate*1e3;
dt = mean(isis)/L;

PRCData.N      = N     ;
PRCData.L      = L     ;
PRCData.y      = y     ;
PRCData.nstim  = nstim ;
PRCData.ntrace = ntrace;
PRCData.isis   = isis  ;
PRCData.dt     = dt    ;

end
function prc = evaluate(obj, prcdata, eta)
% prc = csprc.evaluate(PRCData, eta) computes the PRC via the CS algorithm
% specified by the estimator type.
%
% Inputs
% ======
% PRCData: this structure should contain two fields 'nstim', the rescaled
%          stimuli data, and 'y', the changes in intantaneous firing rates.
%          (see also make_PRC_data).
% eta: error bound. If the estimator type is 'bpexact', this will be
% ignored.
%
%
% Outputs
% =======
% prc: estimated PRC.
%
% Written by: Sungho Hong, CNS Unit, Okinawa Inst of Sci Tech
% Email: shhong@oist.jp
%



A = prcdata.nstim*obj.basis';
xp = obj.estimate_func(A, prcdata.y, eta);
[lxp, mm] = sort(log(abs(xp)));
[~, ii] = max(diff(lxp));
obj.dimK = numel(lxp)-ii;
obj.reldim = mm(end-obj.dimK+1:end);

switch obj.post_proc
    case 'tls'
        xp = tls(A(:,obj.reldim),prcdata.y);
        prc = obj.basis(obj.reldim,:)'*xp;
    case 'pruning'
        xp = linsolve(A(:,obj.reldim),prcdata.y);
        prc = obj.basis(obj.reldim,:)'*xp;
    case 'nothing'
        prc = obj.basis'*xp;
    otherwise
        error('Something has gone wrong about post processing.');
end

end

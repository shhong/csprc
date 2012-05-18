function wsta = getWSTA(PRCData)
% wsta = getWSTA(PRCData) computes the weighted spike-triggered average of
% stimuli (see Ota et al. Phys Rev Lett (2009))
%
% Input
% =====
% PRCData created by make_PRC_data function.
%
% Output
% ======
% wsta: WSTA estimate of a PRC.
%
% Written by: Sungho Hong, CNS Unit, Okinawa Inst of Sci Tech
% Email: shhong@oist.jp
%


wsta = PRCData.nstim'*PRCData.y/mean(sum(PRCData.nstim'*PRCData.nstim));
end
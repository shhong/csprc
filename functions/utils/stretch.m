function r = stretch(s_, N_)
% new_signal = stretch(signal, length_of_new_signal) extra/interpoles a row
% vector that preserves the Fourier coefficients. Maybe MATLAB resample
% function does it right, but I want to make sure. 
%
% Inputs
% ======
% signal: original signal
% length_of_new_signal: length of new signal that should be an _odd_
% number since the number of Fourier basis vectors created by dftBasis will
% be alwayas an odd number.
%
% Written by: Sungho Hong, CNS Unit, Okinawa Inst of Sci Tech
% Email: shhong@oist.jp
%

if size(s_,2)==1
    is_s_row = false;
    s = s_;
else
    is_s_row = true;
    s = reshape(s_,[numel(s_) 1]);
end

if mod(N_,2)==0
    error('Length of the new signal should be an odd number for some reasons. Sorry.')
end

L = numel(s);
x = fft(s);
LL = floor(L/2);
N = floor(N_/2);

if (N<=LL-1)
    x = [x(1); x(2:(N+1)); x(end-(N-1):end)];
else
    x = [x(1); x(2:LL); zeros(2*(N-LL)+2,1); x(end-(LL-2):end)];
end

r = ifft(x)*sqrt(N_/L);

if is_s_row
    r = r';
end

end
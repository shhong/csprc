function basis = dftBasis(L_, M)
% u = dftBasis(L, N) generates the (NxL) Fourier basis matrix u where L is the
% length of each basis vector. If M is not specified, N = (L-1)/2.
%
%
% Written by: Sungho Hong, CNS Unit, Okinawa Inst of Sci Tech
% Email: shhong@oist.jp
%

if (isstruct(L_)), L = size(L_.nstim,2); else L = L_; end
if (nargin==1), M = (L-1)/2; end
MM = 2*M+1;

basis = zeros(MM,L);

t = 2*pi/L*(0:(L-1));

basis(1,:) = ones(1,L)/sqrt(L);
NN = sqrt(2/L);

for i=1:M
    basis(2*i,:) = cos(t*i)*NN;
    basis(2*i+1,:) = sin(t*i)*NN;
end

end
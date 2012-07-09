function basis = sinBasis(L_, M)
% u = sinBasis(L, N) generates the (NxL) sin basis matrix u where L is the
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

t = pi/L*(0:(L-1));

basis = sin(bsxfun(@times, (1:MM)', t))./sqrt(L/2);

function basis = legcBasis(L_, M)
% u = legcBasis(L, N) generates the (NxL) basis matrix u where L is the
% length of each basis vector from associated Legendre polynomial P^2_m(x).
% If M is not specified, N = (L-1)/2.
%
% Written by: Sungho Hong, CNS Unit, Okinawa Inst of Sci Tech
% Email: shhong@oist.jp
%

if (isstruct(L_)), L = size(L_.nstim,2); else L = L_; end
if (nargin==1), M = (L-1)/2; end
MM = 2*M+1;

basis = zeros(MM,L);

t = linspace(-1,1,L);

basis(1,:) = ones(1,L)/sqrt(L);
NN = sqrt(2/L);

for i=1:MM
	temp = legendre(i+1,t);
	basis(i,:) = temp(3,:);
	basis(i,:) = basis(i,:)/norm(basis(i,:));
end

end
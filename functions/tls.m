function x = tls(A,y)
% x = tls(A, y) computes a total least-squares solution via the standard
% SVD method.
%
% Written by: Sungho Hong, CNS Unit, Okinawa Inst of Sci Tech
% Email: shhong@oist.jp
%

[u,s,v] = svd([A y]);

x = -v(1:end-1,end)/v(end,end);

end
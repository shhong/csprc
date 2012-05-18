% BPDN_homotopy_function.m
% 
% Solves the following basis pursuit denoising (BPDN) problem
% min_x  \tau ||x||_1 + 1/2*||y-Ax||_2^2
%
% Inputs: 
% A - m x n measurement matrix
% y - measurement vector
% tau - final value of regularization parameter
% maxiter - maximum number of homotopy iterations
%
% Outputs:
% x_out - output for BPDN
% gamma_x - support of the solution
% total_iter - number of homotopy iterations taken by the solver
% total_time - time taken by the solver
% 
% Written by: Salman Asif, Georgia Tech
% Email: sasif@ece.gatech.edu
%
%-------------------------------------------+
% Copyright (c) 2007.  Muhammad Salman Asif 
%-------------------------------------------+

function [x_out, gamma_x, total_iter, total_time] = BPDN_homotopy_function(A, y, tau, maxiter);

import utils.pursuits_homotopy.*

t0 = cputime;
N = size(A,2);
K = size(A,1);
if (nargin < 4), maxiter = 10*K;  end

% Initialization of primal and dual sign and support
z_x = zeros(N,1);
gamma_x = [];       % Primal support

% Initial step
Primal_constrk = -A'*y;
[c i] = max(abs(Primal_constrk));

gamma_xk = i;

epsilon = c;
xk_1 = zeros(N,1);

z_x(gamma_xk) = -sign(Primal_constrk(gamma_xk));
Primal_constrk(gamma_xk) = sign(Primal_constrk(gamma_xk))*epsilon;

z_xk = z_x;

% loop parameters
done = 0;
iter = 0;
data_precision = eps;   % floating point precision

old_delta = 0;
out_x = [];
count_delta_stop = 0;

constraint_plots = 1;

AtgxAgx = A(:,gamma_xk)'*A(:,gamma_xk);
iAtgxAgx = inv(A(:,gamma_xk)'*A(:,gamma_xk));

while iter < maxiter
    iter = iter+1;
    % warning('off','MATLAB:divideByZero')

    gamma_x = gamma_xk;
    z_x = z_xk;
    x_k = xk_1;

    %%%%%%%%%%%%%%%%%%%%%
    %%%% update on x %%%%
    %%%%%%%%%%%%%%%%%%%%%
    
    % Update direction 
    % del_x = inv(A(:,gamma_x)'*A(:,gamma_x))*z_x(gamma_x);
    del_x = iAtgxAgx*z_x(gamma_x);
    del_x_vec = zeros(N,1);
    del_x_vec(gamma_x) = del_x;

    pk = Primal_constrk;
    %dk = A'*(A*del_x_vec);
    Agdelx = A(:,gamma_x)*del_x;
    % dk = A'*Agdelx;
    dk = A'*(A(:,gamma_x)*del_x);
    
    %%% CONTROL THE MACHINE PRECISION ERROR AT EVERY OPERATION: LIKE BELOW. 
    pk_temp = Primal_constrk;
    gammaL_temp = find(abs(abs(Primal_constrk)-epsilon)<min(epsilon,2*eps));
%     pk_temp(gammaL_temp) = sign(Primal_constrk(gammaL_temp))*epsilon;
    
    xk_temp = x_k;
    gammaX_temp = find(abs(x_k)<1*eps);
%     xk_temp(gammaX_temp) = 0;
    %%%---
    
    % Compute the step size
    [i_delta, out_x, delta, chk_x] = update_primal(gamma_x, gamma_x, z_x,  xk_temp, del_x_vec, pk_temp, dk, epsilon, out_x);

    if old_delta < 4*eps && delta < 4*eps 
        count_delta_stop = count_delta_stop + 1;
    else
        count_delta_stop = 0;
    end
    if count_delta_stop >= 500
        disp('stuck somewhere');
        break;
    end
    old_delta = delta;
    
    xk_1 = x_k+delta*del_x_vec;
    Primal_constrk = pk+delta*dk;
    epsilon_old = epsilon;
    epsilon = epsilon-delta;

    if epsilon <= tau;
        xk_1 = x_k + (epsilon_old-tau)*del_x_vec;
        total_time= cputime-t0;
        break;
    end

    if chk_x == 1
        % If an element is removed from gamma_x
        gx_old = gamma_x; 
        len_gamma = length(gamma_x);
        
        outx_index = find(gamma_x==out_x);
        gamma_x(outx_index) = gamma_x(len_gamma);
        gamma_x(len_gamma) = out_x;
        gamma_xk = gamma_x(1:len_gamma-1);
        
        rowi = outx_index; % ith row of A is swapped with last row (out_x)
        colj = outx_index; % jth column of A is swapped with last column (out_lambda)
        AtgxAgx_ij = AtgxAgx;
        temp_row = AtgxAgx_ij(rowi,:);
        AtgxAgx_ij(rowi,:) = AtgxAgx_ij(len_gamma,:);
        AtgxAgx_ij(len_gamma,:) = temp_row;
        temp_col = AtgxAgx_ij(:,colj);
        AtgxAgx_ij(:,colj) = AtgxAgx_ij(:,len_gamma);
        AtgxAgx_ij(:,len_gamma) = temp_col;
        iAtgxAgx_ij = iAtgxAgx;
        temp_row = iAtgxAgx_ij(colj,:);
        iAtgxAgx_ij(colj,:) = iAtgxAgx_ij(len_gamma,:);
        iAtgxAgx_ij(len_gamma,:) = temp_row;
        temp_col = iAtgxAgx_ij(:,rowi);
        iAtgxAgx_ij(:,rowi) = iAtgxAgx_ij(:,len_gamma);
        iAtgxAgx_ij(:,len_gamma) = temp_col;
        
        AtgxAgx = AtgxAgx_ij(1:len_gamma-1,1:len_gamma-1);
        iAtgxAgx = update_inverse(AtgxAgx_ij, iAtgxAgx_ij,2);
        xk_1(out_x) = 0;
    else
        % If an element is added to gamma_x
        gamma_xk = [gamma_x; i_delta];
        new_x = i_delta;

        AtgxAnx = A(:,gamma_x)'*A(:,new_x);
        AtgxAgx_mod = [AtgxAgx AtgxAnx; AtgxAnx' A(:,new_x)'*A(:,i_delta)];
        
        AtgxAgx = AtgxAgx_mod;
        iAtgxAgx = update_inverse(AtgxAgx, iAtgxAgx,1);
        xk_1(i_delta) = 0;
        gamma_x = gamma_xk;
    end

    z_xk = zeros(N,1);
    z_xk(gamma_xk) = -sign(Primal_constrk(gamma_xk));
    Primal_constrk([gamma_x]) = sign(Primal_constrk([gamma_x]))*epsilon;
%     figure(1); plot(Primal_constrk)
end
total_iter = iter;
total_time = cputime-t0;
x_out = xk_1;
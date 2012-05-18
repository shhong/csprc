classdef csprc < handle
% PRC estimation via Compressive Sensing
% H = csprc(u, type) returns an PRC estimator of the specified type and
% basis matrix u.
%
% Currently implemented types
% ===========================
% 
% *'bpexact': Exact Basis Pursuit 
% There must be l1pd function from the l1-MAGIC package (by Justin Romberg) in the path.
% 
% *'bndn': Basis Pursuit DeNoising
% *'dantzig': Dantzig selector.
% These rely on the BPDN_homotopy_function and DS_homotopy_function in the
% l1-homotopy package (by Salman Asif).
%
% *'dantzig+pruning'
% *'dantzig+tls'
% These do post-processing after compressive sensing estimation.
% 'dantzig+pruning' computes the least square solution by using the sparse
% basis found by the Dantzig selector. 'dantzig+tls' computes the
% total least-squares estimation instead of the least square.
%
% Written by: Sungho Hong, CNS Unit, Okinawa Inst of Sci Tech
% Email: shhong@oist.jp
%
 
    properties
        basis;
        estimate_func;
        error_func;
        dimK;
        post_proc;
        reldim;
    end
	
    methods
        function obj = csprc(basis, method)
            obj.basis = basis;
            obj.dimK = size(basis,1);
            obj.error_func = @(prc,data) norm(data.y-data.nstim*prc)^2;
            obj.post_proc = 'nothing';
            obj.reldim = [];
            switch lower(method)
				case 'bpexact'
					obj.estimate_func = @l1eq_pd_mod;
                case 'bpdn'
                    obj.estimate_func = @BPDN_homotopy_function;
                case 'dantzig'
                    obj.estimate_func = @DS_homotopy_function;
                case 'dantzig+pruning'
                    obj.estimate_func = @DS_homotopy_function;
                    obj.post_proc = 'pruning';
                case 'dantzig+tls'
                    obj.estimate_func = @DS_homotopy_function;
                    obj.error_func = ...
                        @(prc,data) norm(data.y-data.nstim*prc)^2/(1+norm(prc)^2);
                    obj.post_proc = 'tls';
                otherwise
                    error('Unknown method.');
            end
        end
        
        function r = reset(obj)
            r = 1;
            obj.dimK = size(obj.basis,1);
            obj.reldim = [];
        end
        
        prc = evaluate(obj, prcdata, eta)
        
    end
end

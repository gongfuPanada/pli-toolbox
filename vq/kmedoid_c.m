function [L, s, objv, mincost, cnts] = kmedoid_c(C, K, varargin)
%KMEDOID k-Medoid clustering based on pre-computed cost matrix
%
%   [L, s] = KMEDOID_C(C, K, ...);
%   [L, s] = KMEDOID_C(C, s0, ...);
%
%       Performs K-medoid clustering on a pre-computed cost table
%       given by an n x n matrix C.
%
%   [L, s, objv] = KMEDOID_C(C, K, ...);
%   [L, s, objv, minds] = KMEDOID_C(C, K, ...);
%   [L, s, objv, minds, cnts] = KMEDOID_C(C, K, ...);
%       
%       With more output arguments, this function returns additional
%       information about the result.
%
%   Arguments
%   ----------
%   - C :       The pre-computed matrix of size n x n. C(i, j) is the
%               cost of assigning sample j to a cluster with the i-th
%               sample being the center.
%
%   - K :       The number of centers
%
%   - s0 :      The initial selection of centers. It is a vector 
%               of length K.
%
%   Returns
%   -------
%   - L :       The vector of resultant labels, size [1 n].
%
%   - s :       The list of the indices of the samples chosen as centers.
%               size [1 K]
%
%   - objv :    The total cost at the final step.
%
%   - mincost : The cost of assigning each sample to its closest center.
%               size [1 n]. 
%
%               By default the cost equals the squared distance. One can 
%               change the cost function by setting the option costfun.
%
%   - cnts :    The number of samples assigned to each center.
%               size [1 K].
%
%   Options
%   -------
%   - maxiter :     The maximum number of iterations.
%                   (default = 200)
%
%   - tolfun :      The tolerance of obvjective function changes
%                   at convergence. (default = 1.0e-8)
%
%   - display :     The level of information display. 
%                   'off' | 'final' | {'iter'}.
%
%   - init :        The method to initialize the centers. It can take
%                   either of the following values
%                   - 'kmpp' : Using Kmeans++ method (call kmpp_seeds)
%                   - 'rand' : Randomly select K samples as seeds.
%                   default = 'kmpp'.
%

%% argument checking

if ~(ismatrix(C) && isfloat(C) && isreal(C) && size(C,1) == size(C,2))
    error('kmedoid_c:invalidarg', 'C should be a real square matrix.');
end
n = size(C, 1);

if isvector(K) && isnumeric(K) && isreal(K)
    if isscalar(K) 
        if ~(K > 1 && K == fix(K))
            error('kmedoid_c:invalidarg', ...
                'K should be a positive integer with K > 1.');
        end
        s0 = [];
    else
        s0 = K;
        K = numel(s0);
        
        if size(s0, 1) > 1  % make it a row
            s0 = s0.';
        end
    end
    if K >= n
        error('kmedoid_c:invalidarg', ...
            'The value of K should be less than the number of samples.');
    end
else
    error('kmedoid_c:invalidarg', 'The second argument is invalid.');
end

% parse options

opts.maxiter = 200;
opts.tolfun = 1.0e-8;
opts.display = 'iter';
opts.init = 'kmpp';

if ~isempty(varargin)
    opts = parse_opts(opts, varargin);
end

displevel = check_options(opts);


%% main

% initialize centers

if isempty(s0)
    switch opts.init
        case 'kmpp'
            s = kmpp_seed(X, K, cfun);
        case 'rand'
            s = sample_wor(n, K);
        otherwise
            error('kmedoid:invalidarg', ...
                'Invalid value for the option init.');
    end
else
    s = s0;
end









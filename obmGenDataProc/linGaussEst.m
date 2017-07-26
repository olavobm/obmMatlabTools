function y = linGaussEst(tx, x, decorScale, xnoise, ty)
% y = LINGAUSSEST(tx, x, decorScale, xnoise, ty)
%
%   inputs:
%       - tx: independent variable of x.
%       - x: depedent variable to be used to compute y.
%       - decorScale: decorrelation scale
%       - xnoise: noise (error) of x.
%       - ty: points to make an estimate of x.
%
%   outputs:
%       - y: estimate of the quantity x at the points ty.
%
%
% NaNs????
%
% Olavo Badaro Marques, 23/Mar/2017.


%%

lok = ~isnan(x);

if ~any(lok)
    error('NaNs only in the input. There is no data.')
end

tx = tx(lok);
x = x(lok);


%%

n = length(x);

x = x(:);

if length(xnoise) == 1
    xnoise = repmat(xnoise, 1, n);
end

%
tx = tx(:);    % make sure it is a column vector
txGrid = tx * ones(1, n);
txGridaux = txGrid';

% Data-data covariance matrix:
ddCov = exp(-( (txGrid - txGridaux)./decorScale).^2 );
ddCov = ddCov + diag(xnoise);

% Data-grid covariance matrix:
ty = ty(:);
tyGrid = ty * ones(1, n);
% tyGrid = tyGrid';
txRep = ones(length(ty), 1) * tx';

dgCov = exp(-((txRep - tyGrid)/decorScale).^2);

% skill(:, n) = diag(ct/cov*ct');

% Estimate values at the grid points ty:
y = dgCov / ddCov * x;



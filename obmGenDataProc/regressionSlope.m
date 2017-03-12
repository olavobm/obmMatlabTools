function a = regressionSlope(x, y)
% a = REGRESSIONSLOPE(x, y)
%
%   inputs:
%       - x: vector or matrix.
%       - y: vector or matrix.
%
%   outputs:
%       - a: array with regression slopes (see
%            notes below for the size of a).
%
% REGRESSIONSLOPE computes the regression slope a of the linear
% model y* = a x. This constant is determined by minimizing the
% mean square error between the model y* and the variable y.
%
% If inputs x and y are vectors, then a is a single number. If one
% is a vector and the other is a matrix, then output is a vector
% where each element is the regression slope between the vector
% and each row of the matrix. If both inputs are matrices, the
% j'th column of a has the regression slopes of the j'th row of x
% with each column of y.
%
% If inputs x and y are complex vectors, then a is also complex.
% If for example the magnitude of a is 1 and its argument is pi/2,
% then the linear model y* is a counterclockwise rotation of x
% with no change in magnitude. Note the regression does not say
% anything about how good (how correlated) the model is.
%
% Non-zero means? More correctly: non-zero y-crossing???
%
% What about NaNs??
%
% Olavo Badaro Marques, 10/Mar/2017.


%%


if ~iscolumn(x)
    x = x.';   % transpose without taking the complex conjugate
end

if ~iscolumn(y)
    y = y.';
end

% if 

%%

nx = size(x, 2);
ny = size(y, 2);


%% Compute regression slope:

a = NaN(ny, nx);

for i1 = 1:ny
    
    for i2 = 1:nx
        
            a(i1, i2) = (x(:, i2)' * y(:, i1)) / (x(:, i2)' * x(:, i2));
            
    end
    
end


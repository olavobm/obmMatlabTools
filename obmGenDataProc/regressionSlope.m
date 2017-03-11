function a = regressionSlope(x, y)
% a = REGRESSIONSLOPE(x, y)
%
%   inputs:
%       - x:
%       - y:
%
%   outputs:
%       - a:
%
% REGRESSIONSLOPE computes the regression slope a of the linear
% model y* = a x. This constant is determined by minimizing the
% mean square error between the model y* and the variable y.
%
% If inputs x and y are complex vectors....
%
% Non-zero means? More correctly: non-zero y-crossing???
%
% If inputs x and y are matrices...
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


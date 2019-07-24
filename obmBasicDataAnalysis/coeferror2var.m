function [errorvar, errorvarint, varall] = coeferror2var(a, b, errcoef, Nit)
% [errorvar, errorvarint] = COEFERROR2VAR(a, b, errcoef, Nit)
%
%   inputs
%       - a:
%       - b:
%       - errcoef:
%       - Nit:
%
%   outputs
%       - errorvar:
%       - errorvarint:
%       - varall:
%
%
% Olavo Badaro Marques, 23/Jul/2019.


%%

%
meanvar = 0.5 .* (a.^2 + b.^2);

%
Npts = length(meanvar);


%%

% 
au_err = errcoef .* randn(Npts, Nit);
bu_err = errcoef .* randn(Npts, Nit);


%%

%
varall = NaN(Npts, Nit);

%
for i = 1:Nit
    
    %                   
    varall(:, i) = 0.5 .* ((a + au_err(:, i)).^2 + ...
                           (b + bu_err(:, i)).^2);
    
end


%%

%
varallint = sum(varall, 1);


%%

%
errorvar = std(varall, 0, 2);

% This assumes that values in the vertical are
% statistically independent from one another.
errorvarint = std(varallint);




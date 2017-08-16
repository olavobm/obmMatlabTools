function outcorr = rowcorr(x, y)
% outcorr = ROWCORR(x, y)
%
%   inputs
%       - x
%       - y
%
%   outputs
%       - x
%
% 
%
% Olavo Badaro Marques, 14/Aug/2017.


%%

%
N = size(x, 1);

%
outcorr = NaN(N, 1);


%%


for i = 1:N
    
    %
    xaux = x(i, :);
    yaux = y(i, :);
    
    %
    corr_aux = corr(xaux(:), yaux(:));
    
    %
    if ~isnan(corr_aux)
        outcorr(i) = corr_aux;
    end
    
end

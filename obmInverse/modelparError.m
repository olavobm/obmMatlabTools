function merror = modelparError(imf, t, dataerror)
% merror = modelparError(imf, t, dataerror)
%
%   inputs
%       - imf: input-model-fit structure (see myleastsqrs.m).
%       - t: independent variable (where we have data).
%       - dataerror: data covariance matrix.
%
%   outputs
%       - merror: model parameters covariance matrix.
%
% MODELPARERROR propagates the error in the data to calculate
% error in the model parameters.
%
% Olavo Badaro Marques, 19/Apr/2017.


%%

dataCovmat = dataerror .* eye(length(t));

G = makeG(imf, t);
Gaux = (G'*G) \ G';


%%

merror = Gaux * dataCovmat * Gaux';

% % merror = modelparCov(dataCovmat, G);

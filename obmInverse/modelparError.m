function merror = modelparError(imf, t, dataerror)
% merror = modelparError(imf, dataerror)
%
%   inputs:
%       - imf: input-model-fit structure (see myleastsqrs.m).
%       - t:
%       - dataerror: data covariance matrix.
%
%   outputs:
%       - merror: model parameters covariance matrix.
%
%
%
% Olavo Badaro Marques, 19/Apr/2017.



G = makeG(imf, t);


dataCovmat = dataerror .* eye(length(t));

merror = modelparCov(dataCovmat, G);

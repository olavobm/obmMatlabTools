function mCovmat = modelparCov(dataCovmat, G)
% mCovmat = MODELPARCOV(dataCovmat, G)
%
%   inputs
%       - dataCovmat: data covariance matrix.
%       - G: data kernel.
%
%   outputs
%       - mCovmat: model parameters covariance matrix.
%
%
%
% Olavo Badaro Marques, 19/Apr/2017.


Gaux = (G'*G) \ G';

mCovmat = Gaux * dataCovmat * Gaux';
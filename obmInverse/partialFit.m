function [xfit, mout, Gout] = partialFit(lpartfit, m, G)
% [xfit, mout, Gout] = PARTIALFIT(lpartfit, m, G)
%
%  inputs:
%    - lpartfit: logical array indicating which model parameters (and
%                correspondent columns of G) to keep and compute the fit.
%    - m: model parameters (output of function myleastsqrs).
%    - G: G matrix (output of myleastsqrs).
%
%  output:
%    - xfit: fit only keeping the models indicated by lpartfit.
%    - mout: subsetted model parameters.
%    - Gout: subsetted matrix G, such that xfit = Gmout * mout.
%
% - INCLUDE THE EXPLANATION OF MY IMPLEMENTATION OF LPARTFIT CELL ARRAY.
% - IN THIS CASE, EACH COLUMN IS FOR A DIFFERENT ELEMENT IN THE CELL ARRAY.
%
% The function PARTIALFIT takes as input the m and G outputs of the
% function myleastsqrs and computes the fit by only keeping some of
% the models originally fitted. The models taken are indicated by
% the logical array lpartfit, which specify which rows of m (and the
% correspondent columns of G) are kept.
%
% If you are not familiar with the function myleastsqrs, be careful when
% using this function to make sure you are retaining the models you are
% really interested in. For example, if you have fitted a bunch of
% sinusoidal signals with different frequencies and you want want to keep
% only 1 component, you have to keep 2 elements of m (one associated with
% the cosine and other with sine).
%
% Olavo Badaro Marques, 15/Nov/2016.


%% 

if ~iscell(lpartfit)
    
    nfits = 1;
    
    if iscolumn(lpartfit) 
        lpartfit = lpartfit';
    end
    
    if length(lpartfit)~=length(m)
        error('Vector lpartfit have the same length as m!')
    end
    
else
    
    nfits = length(lpartfit);
    
    lpartfitaux = NaN(nfits, length(m));
    
    for i = 1:nfits
        
        if length(lpartfit{i})~=length(m)
            error('Each element of lpartfit have the same length as m!')
        end
        
        lpartfitaux(i, :) = lpartfit{i};
    end
    
    lpartfit = lpartfitaux;
    
end


%% Do the fit based on the subsetted m and G arrays:

npts = size(G, 1);

% Pre-allocate space for output variables:
xfit = NaN(npts, nfits);

mout = NaN(length(m), nfits);
Gout = cell(1, nfits);

% Loop through the different combination of models to be
% kept (nfits is 1 if lpartfit is NOT a cell array):
for i = 1:nfits
    
    lkeep = lpartfit(i, :);
    
    mout(lkeep, i) = m(lkeep);
    Gout{i} = G(:, lkeep);

    xfit(:, i) = Gout{i} * mout(lkeep, i);
    
end




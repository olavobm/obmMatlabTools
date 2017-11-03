function [mdvec, mdval, mdamp, mdcomp] = eof1d(x, neofs)
%
%
%   inputs
%       - x
%       - neofs
%
%   inputs
%       -
%       -
%       -
%
%
%
% Variance explained by each mode is mdvar.^2 ./ sum(mdvar.^2).
%
% Olavo Badaro Marques, 03/Nov/2017.


%%




%%

[U, S, V] = svd(x, 'econ');

% Amplitudes:
mdamp = S * V';
mdamp = mdamp(1:neofs, :);

%
mdval = diag(S);
mdval = mdval(1:neofs);

%
mdvec = U(:, 1:neofs);


% % 
% % %%
% % mdcomp = diag(mdval, 0) * (mdvec');
% % mdcomp = mdcomp';


% % %%
% % 
% % U = U(:,1:neof);
% % s = diag(S.^2)/trace(S.^2);
% % s = s(1:neof);
% % 
% % V = nan(nlat*nlon,neof);
% % V(ii,:) = V2(:,1:neof);
% % 
% % V = reshape(V,nlat,nlon,neof);


% % %%
% % % Temperature:
% % T_EOF = WWdata.T(di:df,:);
% % 
% % [i,j] = ind2sub(size(T_EOF), find(isnan(T_EOF) | isnan(U_EOF)));
% % 
% % j_ok = 1:length(t);
% % j_ok = setdiff(j_ok,j);
% % 
% % T_EOF = T_EOF(:,j_ok);
% % [re,ce] = size(T_EOF);
% % T_EOF = T_EOF - repmat(nanmean(T_EOF,2),1,ce);





function minrmsoutstrct = loop_minrms(xg, yg, xd, yd, x0xendxn)
% minrmsoutstrct = LOOP_AND_MINRMS(xg, yg, yd, dxd, x0dxloop)
%
%   inputs
%       - xg:
%       - yg:
%       - xd:
%       - yd:
%       - x0dxxend: 1x3 vector with the initial location, 
%                   ...... , respectively.
%
%   outputs
%       - struct variable with the fields:
%           *
%           *
%           *
%           *
%
% x need to be sorted!
%
% Olavo Badaro Marques, 13/May/2019.


%%

%
ndpts = length(xd);

%
xd_vec = xd(:);
yd_vec = yd(:);


%%
if (xd(end)>xd(1))
	% Already sorted, do
    lsorted = true;
else
    
    %
    xd_vec = flipud(xd_vec);
    yd_vec = flipud(yd_vec);
    
    lsorted = false;
end

%
xdiff_vec = diff(xd_vec);



%%

%
allx0 = x0xendxn(1) : x0xendxn(3) : x0xendxn(2);

% Switch to this approach
% % allx0 = linspace(x0xendxn(1), x0xendxn(2), x0xendxn(3));





%%
%
xdiff_aux = repmat(xdiff_vec, 1, length(allx0));

%
xdiff_aux = [allx0; xdiff_aux];

%
all_x4loop = cumsum(xdiff_aux, 1);


%% Now interpolate yg on each column of all_x4loop

%
all_yg = NaN(ndpts, length(allx0));

%
for i = 1:ndpts
	all_yg(:, i) = interp1(xg, yg, all_x4loop(:, i));
end


%%

ydmatrix = repmat(yd_vec(:), 1, length(allx0));


%%

%
yddev = ydmatrix - repmat(nanmean(ydmatrix, 1), ndpts, 1);
ygdev = all_yg - repmat(nanmean(all_yg, 1), ndpts, 1);

%
all_rms = sqrt(mean((yddev - ygdev).^2, 1));


%% Get index and the x with min rms

[minrms, ind_minrms] = min(all_rms);


%% Organize output

%
minrmsoutstrct.corr4x = xd_vec(1) - all_x4loop(1, ind_minrms);
minrmsoutstrct.xdcorr = xd_vec + minrmsoutstrct.corr4x;

%
minrmsoutstrct.xgbest = all_x4loop(:, ind_minrms);

%
minrmsoutstrct.allrms = all_rms;
minrmsoutstrct.ind_minrms = ind_minrms;
minrmsoutstrct.minrms = minrms;

%
if (~lsorted)
	minrmsoutstrct.xdcorr = flipud(minrmsoutstrct.xdcorr);
end



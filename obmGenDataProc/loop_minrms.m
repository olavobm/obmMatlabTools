function minrmsoutstrct = loop_minrms(xg, yg, xd, yd, x0xendxn)
% minrmsoutstrct = LOOP_MINRMS(xg, yg, yd, dxd, x0xendxn)
%
%   inputs
%       - xg: a vector with the grid (independent variable)
%             of a variable yg.
%       - yg: a data vector (with same length as xg).
%       - xd: a vector with the independent variable of the data yd.
%       - yd: data vector.
%       - x0xendxn: 1x3 vector with the initial location, 
%                   ...... , respectively.
%
%   outputs
%       - struct variable with the fields:
%           * corr4x:
%           * xdcorr:
%           * xg:
%           * yg:
%           * allxd:
%           * allyd:
%           * allyg:
%           * allrms:
%           * ind_minrms:
%           * minrmsoutstrct.minrms
%
% 
%
% LOOP_MINRMS.m compares yd with several "realizations" of yg
% (as determined by input x0xendxn) and find the correspondent
% x (xdcorr) correspondent with the minimum root-mean-square
% (RMS) error. In essence, LOOP_MINRMS.m is like a regression
% of yd against yg to find the best bias correction to xd.
%
% I originally wrote this function for a very specific problem:
% to estimate the distance between a ship and a towed instrument
% based on depth/altimeter data from the instrument and a bathymetry
% databased.
%
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
for i = 1:length(allx0)
	all_yg(:, i) = interp1(xg, yg, all_x4loop(:, i));
end


%%

ydmatrix = repmat(yd_vec(:), 1, length(allx0));


%%

%
% % yddev = ydmatrix - repmat(nanmean(ydmatrix, 1), ndpts, 1);
% % ygdev = all_yg - repmat(nanmean(all_yg, 1), ndpts, 1);
yddev = ydmatrix;
ygdev = all_yg;

%
all_misfits = yddev - ygdev;

%
all_rms = sqrt(mean(all_misfits.^2, 1));


%% Get index and the x with min rms

[minrms, ind_minrms] = min(all_rms);


%% Organize output

%
minrmsoutstrct.corr4x = all_x4loop(1, ind_minrms) - xd_vec(1);
minrmsoutstrct.xdcorr = xd_vec + minrmsoutstrct.corr4x;

%
minrmsoutstrct.xg = xg;
minrmsoutstrct.yg = yg;

%
minrmsoutstrct.allxd = all_x4loop;
minrmsoutstrct.allyd = ydmatrix;
minrmsoutstrct.allyg = all_yg;

%
% % minrmsoutstrct.allxg = all_x4loop;

%
minrmsoutstrct.allrms = all_rms;
minrmsoutstrct.ind_minrms = ind_minrms;
minrmsoutstrct.minrms = minrms;

% If it is NOT sorted at the beginning, then flip
% output so it has the same corresponding sequence
% as the input
if (~lsorted)
	minrmsoutstrct.xdcorr = flipud(minrmsoutstrct.xdcorr);
end



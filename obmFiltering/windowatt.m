function wndi = windowatt(wnd, tlims, ti, Nwnd)
% wndi = WINDOWATT(wnd, tlims, ti, Nwnd)
%
%   inputs:
%       - wnd: window function handle (see Matlab's function window.m).
%       - tlims: 1x2 vector with the coordinate of the window end points.
%       - ti: 1xN vector with the points in the same dimension as tlims.
%       - Nwnd (optional): number of points used to estimate the window.
%
%   outputs:
%       - wndi: window values at ti.
%
% Computes values of a window function (e.g. hann, hamming, etc.).
% These windows are commonly defined as discrete functions. Function
% WINDOWATT uses tlims to linearly interpolate the values of the
% window function on the points ti.
%
% For input tlims, tlims(2) must be grater than tlims(1). Points in
% ti outside this will have a window value wndi of 0.
%
% The optional input Nwnd is the length of the discrete function.
% A "large" default value is used so as to approximate the window
% as a continous function. However, depending on the dataset, the
% default value may not be large enough, so you cant set it in the
% input.
%
% Olavo Badaro Marques, 28/Apr/2017.


%% Choose default value of Nwnd:

if ~exist('Nwnd','var')    
    Nwnd = 1000;
end


%% Giver warning message if the number of points
% is above a certain threshold relative to Nwnd:

lenlim = 0.1;    % percentage threshold
Nti = length(ti);

if Nti > lenlim*Nwnd
    warning(['Window with length of ' num2str(Nwnd) ' points is ' ...
             'being used to estimate values for ' ...
             '' num2str(Nti) '. You may want to ' ...
             'consider increasing Nwnd in ' mfilename '.'])
end


%% Create window with Nwnd number of points:

windowWeights = window(wnd, Nwnd);
windowWeights = windowWeights';
twindow = linspace(tlims(1), tlims(2), Nwnd);


%% Interpolate window values at ti:

wndi = interp1(twindow, windowWeights, ti);

% Set values outside the range tlims to 0 (which
% have NaNs assigned by the function interp1):
loutwnd = isnan(wndi);
wndi(loutwnd) = 0;


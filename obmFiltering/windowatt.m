function wndi = windowatt(wnd, tlims, ti, Nwnd)
% wndi = WINDOWATT(wnd, tlims, ti)
%
%   inputs:
%       - wnd:
%       - tlims:
%       - ti:
%       - Nwnd (optional):   
%
%   outputs:
%       - wndi:
%
%   
%
% Olavo Badaro Marques, 28/Apr/2017.


%%

if ~exist('Nwnd','var')    
    Nwnd = 1000;
end


%%

windowWeights = window(wnd, Nwnd);
windowWeights = windowWeights';
twindow = linspace(tlims(1), tlims(2), Nwnd);


%%

wndi = interp1(twindow, windowWeights, ti);

loutwnd = isnan(wndi);
wndi(loutwnd) = 0;


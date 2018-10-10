function [x, h, dhdx] = tanhprofile(Xmax, Hright, Hleft, WidthR, WidthSlope, nx)
% [x, h, dhdx] = TANHPROFILE(Xmax, Hright, Hleft, WidthR, WidthL, nx)
%
%   inputs
%       - Xmax:
%       - Hmin:
%       - Hmax:
%       - WidthHmin:
%       - WidthHmax:
%       - nx:
%
%   outputs
%       - x:
%       - h:
%       - dhdx:
%
% Olavo Badaro Marques, 10/Oct/2018.


%% Example

if nargin==0
    
    %
    nx = 500;
    Xmax = 300000;

    %  ocean and shelf dimensions
    Hleft = 4000 ;       %  Depth of deep ocean
    Hright =  250 ;      %  Depth of shelf

    WidthR = -75000 ;    %  Width of shelf
    WidthSlope = 25000 ;    %  Width of slope
    
end



%% Define the x-grid

dx = Xmax/nx;
x = dx*(0:1:nx-1);
x = x - max(x);
                   
%
h = Hleft - 0.5 * (Hleft - Hright) * (1 + tanh((x - WidthR)/WidthSlope)) ;

% Bottom slope
% dhdx = -(0.5*(H0-Hsh)/DXsl)*sech((x-Xsh)/DXsl).^2 ;

% % h = 
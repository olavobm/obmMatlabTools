function [uvtrans] = arrowPlotTransform(uv, lenhei, xyran, xy0, rotang)
% [uvtrans] = ARROWPLOTTRANSFORM(uv, lenhei, xyran, xy0)
% 
%   inputs:
%       - uv: 2xN array of 2D vectors.
%       - lenhei: 1x2 array with horizontal/vertical lengths
%                 lenhei(1)/lenhei(2) in centimeters.
%       - xyran: 1x4 array with the x/y axes limits of a plot.
%       - xy0: 2xN array with vector tail positions, in the
%              coordinate system of xyran.
%       - rotang: 1xN rotation angle, in radians, for an additional
%                 counterclockwise rotation of the vectors uv.
%
% Transform the vectors uv from their coordinate system to the coordinate
% system of xyran taking into account the aspect ratio defined by lenhei.
% In other words, the argument of a vector uv is the same as the appearance
% of uvtrans in a plot with aspect ratio defined by the length lenhei(1)
% and height lenhei(2).
%
% Function ARROWPLOTTRANSFORM is called by plotArrows
%
% Olavo Badaro Marques, 13/Dec/2016.


%%

if ~exist('rotang', 'var')
    rotang = 0;
end


%%
S1 = [1/lenhei(1),      0      ; ...
           0     , 1/lenhei(2) ];

       
S2 = S1;
S2(1, 1) = xyran(1) * S2(1, 1);
S2(2, 2) = xyran(2) * S2(2, 2);

% Pre-allocate space for the output:
nvecs = size(uv, 2);
uvtrans = NaN(size(uv));


% USE THE ROTATION!!! (MEANING, FOR EVERY VECTOR, PROVIDE MAGNITUDE AND
% ARGUMENT INSTEAD OF ITS COMPONENTS)
uvmag = sqrt(uv(1, :).^2 + uv(2, :).^2);
uvdir = atan2(uv(2, :), uv(1, :));   % do not need to divide by uvmag

rotang = uvdir + rotang;

%
uv2rot = [uvmag; zeros(1, nvecs)];

%    
for i = 1:nvecs

    R = [cos(rotang(i)), -sin(rotang(i)); ...
         sin(rotang(i)),  cos(rotang(i))];

    % Why does the order matter???????????
    uvtrans(:, i) = S2 * R * S1 * uv2rot(:, i);
    % uvtrans = S2 * S1 * R * uv;
end


%
uvtrans = uvtrans + xy0;


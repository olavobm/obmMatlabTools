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


%% Check if optional input rotang was
% specified. If not use default value of 0:

if ~exist('rotang', 'var')
    rotang = 0;
end


%% Define the matrices S1 and S2 that are part of the transformation:

% Matrix S1:
S1 = [1/lenhei(1),      0      ; ...
           0     , 1/lenhei(2) ];


% Matrix S2:
S2 = S1;
S2(1, 1) = xyran(1) * S2(1, 1);
S2(2, 2) = xyran(2) * S2(2, 2);


%% Get magnitude and argument of vectors uv:

%
uvmag = sqrt(uv(1, :).^2 + uv(2, :).^2);
uvdir = atan2(uv(2, :), uv(1, :));  % do not need to divide by
                                    % uvmag thanks to Matlab

% Rotation angle:
rotang = uvdir + rotang;


%% Do the transformation

% Pre-allocate space for the output:
nvecs = size(uv, 2);
uvtrans = NaN(size(uv));

% Create vector along x axis with the magnitude of uv:
uv2rot = [uvmag; zeros(1, nvecs)];

% Loop through all uv(:, i) vectors and apply the transformation:
for i = 1:nvecs

    % Rotation matrix:
    R = [cos(rotang(i)), -sin(rotang(i)); ...
         sin(rotang(i)),  cos(rotang(i))];

    % Why does the order matter???????????
    uvtrans(:, i) = S2 * R * S1 * uv2rot(:, i);
    % uvtrans = S2 * S1 * R * uv;
end


%% Translate vectors uvtrans to their vector tail positions xy0:

uvtrans = uvtrans + xy0;


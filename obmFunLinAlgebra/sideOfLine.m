function lout = sideOfLine(xyline, x, y)
% lout = SIDEOFLINE(xyline, x, y)
%
%   inputs:
%       - xyline: 1x4 double array with two coordinates on a 2D plane
%                 ([x1, y1, x2, y2]) defining a line.
%       - x: x coordinates in the 2D plane.
%       - y: y      "       "  "   "   " (same size as x).
%
%   outputs:
%       - lout: logical array, the same size as x/y, where true and
%               false indicate whether the coordinate is on the left
%               or right side of the line (see description below).
%
% SIDEOFLINE takes the cross product of the vector defined by xyline
% and the coordinates (x, y). If the magnitude of the product is
% greater (smaller) than zero then the coordinate is to the left
% (right) of the line defined by xyline -- when looking down from
% (x1, y1) to (x2, y2). This can be thought of as the right-hand rule.
% 
% The output is also true for points on the line (where the
% cross product is zero). Should I include another input for
% points on the line???
%
% Olavo Badaro Marques, 22/Feb/2017.


%% Create the vector defining the line:

vecline = [xyline(3)-xyline(1), xyline(4)-xyline(2)];


%% Create vectors for each coordinate (x, y) 
% starting from the same coordinate as xyline(1:2):

x_vecpoints = x - xyline(1);

y_vecpoints = y - xyline(2);


%% Take the cross product and assign output:

crossprod = (vecline(1) .* y_vecpoints) - ...
            (vecline(2) .* x_vecpoints);

lout = (crossprod >= 0);

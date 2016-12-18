function [uvtrans] = arrowPlotTransform(uv, lenhei, xyran, xy0, rotang)
% [uvtrans] = ARROWPLOTTRANSFORM(uv, lenhei, xyran, xy0)
% 
%   inputs:
%       - uv:
%       - lenhei:
%       - xyran:
%       - xy0:
%       - rotang:
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


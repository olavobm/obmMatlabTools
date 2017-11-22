function hplt = plot3Dprof(z, u, v, varargin)
% hplt = PLOT3DPROF(z, u, v, varargin)
%
%   inputs
%       -
%       -
%       -
%       -
%
%   outputs
%       -
%
%
%
%
%

%%

z = z(:);
u = u(:);
v = v(:);

N = length(z);


%%

%
uplt = [zeros(1, N); NaN(2, N); zeros(1, N)];
vplt = [zeros(1, N); NaN(2, N); zeros(1, N)];

%
uplt(2:3, :) = [u'; u'];
vplt(2:3, :) = [v'; v'];


%%

dz = z(2) - z(1);
z1 = z - (dz/2);
z2 = z + (dz/2);

zplt = NaN(4, N);
zplt(1:2, :) = [z1'; z1'];
zplt(3:4, :) = [z2'; z2'];


%%

hplt = fill3(uplt, vplt, zplt, [0.5, 0.5, 0.5]);

%
dataAspectRto = daspect;
daspect([dataAspectRto(1), dataAspectRto(1), dataAspectRto(3)]);


%%
if nargout==0
    clear hplt
end
    
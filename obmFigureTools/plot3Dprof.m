function hplt = plot3Dprof(u, v, z, varargin)
% hplt = PLOT3DPROF(u, v, z, varargin)
%
%   inputs
%       - u: x component to plot.
%       - v: y     "      "   " .
%       - z: vertical location of the vectors (u, v).
%       -
%
%   outputs
%       - hplt: handles of the plot (or vertices of the fill plot)
%
%
%
%
% Olavo Badaro Marques, 23/Nov/2017.


%% Set default options for some possible parameter of varargin

%
p = inputParser;

%
defltPlot = true;

%
addParameter(p, 'Plot', defltPlot)

% Fill variable p with default values or input specifications:
parse(p, varargin{:})


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


if p.Results.Plot
    
    
    hplt = fill3(uplt, vplt, zplt, [0.5, 0.5, 0.5]);

    %
    dataAspectRto = daspect;
    daspect([dataAspectRto(1), dataAspectRto(1), dataAspectRto(3)]);
    
else
    
    uvzaux = cat(3, uplt, vplt);
    
    hplt = cat(3, uvzaux, zplt);
      

end


%%

if nargout==0
    clear hplt
end
    
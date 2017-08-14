function plotLoopMovie(x, y, tpause, nkeep, loopstep, varargin)
% PLOTLOOPMOVIE(x, y, tpause, nkeep, loopstep, varargin)
%
%   inputs
%       - x:
%       - y:
%       - tpause:
%       - nkeep:
%       - loopstep:
%       - varargin:
%
%
%
%
%
% Olavo Badaro Marques, 14/Aug/2017.


%%

if ~exist('nkeep', 'var') || isempty(nkeep)
   nkeep = 1; 
end

if ~exist('loopstep', 'var') || isempty(loopstep)
   loopstep = 1; 
end


%%

if isvector(x)
    lloopy = true;
    lendim = size(y, 2);
else
    lloopy = false;    
    lendim = size(x, 2);
end


%%

%
for i = 1:loopstep:lendim

    %
    if lloopy
        hndaux = plot(x, y(:, i));
    else
        hndaux = plot(x(:, i), y);
    end

    if nkeep>1
        %
        hold on
        if i==1
            pltHndls = keepObjects(nkeep, hndaux);
        else
            pltHndls = keepObjects(nkeep, hndaux, pltHndls);
        end
    end

    % Edit plot
    if ~isempty(varargin)
        set(gca, varargin{:});
    end
    
    %
    pause(tpause)
end
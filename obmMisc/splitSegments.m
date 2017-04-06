function [indprof] = splitintoProfiles(t, dt, p, plims)
% [indprof] = SPLITINTOPROFILES(t, dt, p, plims)
%
%   inputs:
%       - t:
%       - dt:
%       - p:
%       - plims (optional):
%
%   outputs:
%       - indprof:
%
%
% Olavo Badaro Marques, 05/Apr/2017.


%%

% % Do this later:
% if exist('plims', 'var')    
%     linplims = (p>=plims(1) & p<=plims(2));
% end


%%

tdiff = diff(t);


ldiffprof = (tdiff >= dt);

inddiffprof = find(ldiffprof);

% nprof = 1 + length(inddiffprof);


%%

% indprof = cell(1, prof);

indbeg = [1, inddiffprof+1];
indend = [inddiffprof, length(t)];

indprof = [indbeg; indend];


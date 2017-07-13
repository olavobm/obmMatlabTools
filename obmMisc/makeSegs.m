function segsLims = makeSegs(nbegend, seglen, segstep)
% segslims = MAKESEGS(nbegend, seglen, segstep)
%
%   inputs:
%       - nbegend:
%       - seglen:
%       - segstep:
%
%   outputs:
%       - segsLims: Nx2 array.
%
% Olavo Badaro Marques, 06/Jul/2017.


%%

segsEnd = (nbegend(1) + seglen) : segstep : nbegend(2);

if segsEnd(end)~=nbegend(2)
    segsEnd = [segsEnd, (segsEnd(end) + segstep)];
end

%
segsBeg = nbegend(1) : segstep : (segsEnd(end)-seglen);

% Assign output
segsLims = [segsBeg(:), segsEnd(:)];

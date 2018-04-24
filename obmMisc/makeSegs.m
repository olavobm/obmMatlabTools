function segsLims = makeSegs(nbegend, seglen, segstep)
% segslims = MAKESEGS(nbegend, seglen, segstep)
%
%   inputs
%       - nbegend: 2-element vector with beginning and end points.
%       - seglen: length of the segments.
%       - segstep: step from the beginning (end) of subsequent segments.
%
%   outputs
%       - segsLims: Nx2 array with beginning (first column)
%                   and end (second column) of each segment.
%
% MAKESEGS.m creates segments of equal length starting at nbegend(1)
% and (with reference) ending at nbegend(2). Note that nbegend(2)
% may NOT necessarily be the last end point in the case where
% the calculated end point is larger than nbegend(2).
%
% Olavo Badaro Marques, 06/Jul/2017.


% Create the end points of the segments
segsEnd = (nbegend(1) + seglen) : segstep : nbegend(2);

if segsEnd(end)~=nbegend(2)
    segsEnd = [segsEnd, (segsEnd(end) + segstep)];
end

% Create the starting points of the segments
segsBeg = nbegend(1) : segstep : (segsEnd(end)-seglen);

% Assign output
segsLims = [segsBeg(:), segsEnd(:)];

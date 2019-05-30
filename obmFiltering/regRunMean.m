function [xmean, indcenter] = regRunMean(npts, x, slidepts, wndwtype, indlims)
% [xmean, indcenter] = REGRUNMEAN(npts, x, slidepts, wndwtype, indlims)
%
%   inputs
%       - npts
%       - slidepts
%       - x
%       - wndwtype
%       - indlims (optional):
%
%   outputs
%       - xmean:
%       - indcenter:
%
% 
%
% For simplicity, this function only deals with odd npts
% (it makes this function a lot simpler). However, npts
% can still be even, but then the npts used is npts-1
% and slidepts skips one point between windows. I wrote
% the code this way because it is very useful to have
% even npts, because there are common cycles with an even
% number of points (e.g. 60 seconds in a minute).
%
% If the variable x is a function of some independent
% variable, make sure this one is evenly spaced before
% calling this function.
%
%
%
% Olavo Badaro Marques, 29/May/2019.


%%

%
if ~isvector(x)
	error('x is not a vector (it must be).')
end

%
if mod(npts, 2)==0
% % 	error('npts is even, but it must be odd.')

    %
    slidepts = npts;
    npts = npts - 1;
% %     slidepts = npts + 1;
end


%%
%

if ~exist('slidepts', 'var') || isempty(slidepts)
    
    %
    lcont = true;
    
    % In this case, I could also make slidepts = npts,
    % and instead have a unified code below for both
    % cases of lcont. However, lcont true is a special
    % case where I don't need to copy elements of x
    % (in case of overlap) and so I can make it more
    % efficient.
    
else
    
    lcont = false;
end


%%

%
N = length(x);

%
if ~exist('indlims', 'var')
	indlims = [1, N];
else
    
    % check if indlims is appropriate
    
end


%% Find the indices of the values of x that will be averaged
% as well as the number of segments. As written above, I
% could have written the same piece of code for both cases
% but the later one can be less efficient (though even that
% is efficient)

%
if lcont
    %%
    
	%
    ind_leftedge_first = indlims(1);

    %
    nallpts = indlims(2) - indlims(1) + 1;

    %
    allptsmodwindow = mod(nallpts, npts);
    inds_rightedge_last = nallpts - allptsmodwindow + indlims(1) - 1;

    %
    nallavgpts = inds_rightedge_last -  ind_leftedge_first + 1;

    %
    nsegs = nallavgpts / npts;
    
    %
    allindsavg = ind_leftedge_first : inds_rightedge_last;
    
else
    %%
    %
    ind_leftedge_all = indlims(1) : slidepts : indlims(2);

    %
    ind_rightedge_all = ind_leftedge_all + npts - 1;

    linrange = ind_rightedge_all <= indlims(2);

    %
    ind_leftedge_all = ind_leftedge_all(linrange);
    ind_rightedge_all = ind_rightedge_all(linrange);

    %
    nsegs = length(ind_leftedge_all);

    %
    allindsavg = NaN(npts, nsegs);
    for i = 1:nsegs
        allindsavg(:, i) = ind_leftedge_all(i) : 1 : ind_rightedge_all(i);
    end
    
    %
    allindsavg = allindsavg(:);

end


%%

xmatrix = reshape(x(allindsavg), npts, nsegs);
    

%% Create window with length equal to npts
%  (Matlab returns a column vector)

filterwindow = window(wndwtype, npts);


%% Multiply the rearranged x by the window

%
filterwindow_matrix = repmat(filterwindow, 1, nsegs);

%
xmatrix = xmatrix .* filterwindow_matrix;


%% Take the average

xmean = sum(xmatrix, 1) ./ sum(filterwindow);


%% Calculate the indices corresponding
% to the center of all windows

%
npts_side = floor(npts/2);

%
if lcont
    
    indcenter = (ind_leftedge_first + npts_side) : npts : indlims(2);
    
else
    indcenter = ind_leftedge_all + npts_side;
end

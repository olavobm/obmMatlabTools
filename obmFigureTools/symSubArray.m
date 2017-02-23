function axshndls = symSubArray(mxy, mixy, nxy, lmake)
% SYMSUBARRAY(mxy, mixy, nxy, lmake)
%
%   inputs:
%       - mxy: 1x1 or 1x2 array.
%       - mixy: 1x1 or 1x2 array.
%       - nxy: number of subplots
%       - lmake (optional): logical vector with false for the subplots
%                           you do not want to create (such that you
%                           can make an irregular grid of sublots).
%                           Default is true for all.
%
%   output:
%       - axshndls: subplot handles.
%
% SYMSUBARRAY calls makeSubPlots.m to create a new figure with an
% array of subplots. The simplification of SYMSUBARRAY is that opposite
% margins (or all of them) have the same length.
%
% See also: MAKESUBPLOTS
%
% Olavo Badaro Marques, 10/Feb/2017.


%% Repeat mxy and mixy if necessary:

if length(mxy)==1
    mxy = [mxy, mxy];
elseif length(mxy)>2
    error('not allowed!') 
end

if length(mixy)==1
    mixy = [mixy, mixy];
elseif length(mixy)>2
    error('not allowed!') 
end


%% Check optional input lmake:

if ~exist('lmake', 'var')
	lmake = true(1, nxy(1)*nxy(2));
end


%% Call function that creates all subplots:

axshndls = makeSubPlots(mxy(1), mxy(1), mixy(1), ...
                        mxy(2), mxy(2), mixy(2), ...
                        nxy(1), nxy(2), lmake);
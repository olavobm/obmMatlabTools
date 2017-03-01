function gobjArray = keepObjects(nkeep, newObj, gobjArray)
% gobjArray = KEEPOBJECTS(nkeep, newObj, gobjArray)
%
%   inputs:
%       - nkeep: number of graphics objects to keep on axes.
%       - newObj: new graphics object to add to gobjArray.
%       - gobjArray: graphics object array created by previous call
%                    of this function. If not given as input, create
%                    a new array.
%
%   outputs:
%       - gobjArray: input gobjArray updated with newObj.
%
% KEEPOBJECTS creates (or updates) a graphics object array of
% size (nkeep x 1).
%
% This function was designed to keep only a limited number of plots
% when plotting at every iteration of a loop, effectively creating
% an animation where only the plots from the last nkeep iterations
% are shown.
%
% When calling this function for the first time (without giving
% gobjArray as input), the output is an array of size (nkeep x 1),
% whose first element is newObj and the others are of class
% matlab.graphics.GraphicsPlaceholder (which is an empty graphics
% object). When calling this function again, newObj is assigned to
% the next element of the array. When gobjArray is full, the
% calling keepObjects deletes gobjArray(1), moves remaining objects
% to gobjArray(1:end-1) and adds newObj to gobjArray(end).
%
% Olavo Badaro Marques, 28/Feb/2017.


%% If gobjArray is not given as input, then
% create an array of empty graphics objects:

if ~exist('gobjArray', 'var')
    gobjArray = gobjects(nkeep, 1);
end


%% Add newObj to gobjArray:

if ~all(isgraphics(gobjArray))
    %% Add to the first empty element of gobjArray:
    
    indNext = find(~(isgraphics(gobjArray)), 1, 'first');
    
    % Instead of the above, I kind of prefer to loop
    % and use this line:
    % isa(bla, 'matlab.graphics.GraphicsPlaceholder')
    
    gobjArray(indNext) = newObj;
    
    
else
    %% Or add to the last element, after erasing the first one:
    
    delete(gobjArray(1))
    gobjArray(1) = gobjects(1);  % make the first one empty
                                 % (probably not necessary)
    
    gobjArray(1:end-1) = gobjArray(2:end);
    gobjArray(end) = newObj;
    
end



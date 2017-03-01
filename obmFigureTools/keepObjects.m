function objectsVec = keepObjects(nkeep, objectsVec, newObj)
% objectsVec = KEEPOBJECTS(nkeep, objectsVec)
%
%   inputs:
%       - nkeep:
%       - objectsVec:
%       - newObj:
%
%   outputs:
%       - objectsVec:
%
%
% Olavo Badaro Marques, 28/Feb/2017.


%%

if ~exist('objectsVec', 'var')
    objectsVec = gobjects(nkeep, 1);
end

% I kind of prefer to loop and use this line
% isa(bla, 'matlab.graphics.GraphicsPlaceholder')



%%


if ~all(isgraphics(objectsVec))

    indNext = find(~(isgraphics(objectsVec)), 1, 'first');
    
    objectsVec(indNext) = newObj;
    
else
    
    delete(objectsVec(1))
    objectsVec(1) = gobjects(1);
    
    objectsVec(end) = newObj;
    
end




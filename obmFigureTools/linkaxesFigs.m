function linkaxesFigs(hfigs, axsstr)
% LINKAXESFIGS(hfigs, axsstr)
%
%   inputs:
%       - hfigs: vector of figure handles (or figure numbers).
%       - axsstr: string in the same manner as it goes into linkaxes.m
%
% By using my other function (linkallaxes.m), LINKAXESFIGS links all axes
% in figures specified by their handles (or numbers) in input hfigs.
%
% See also: linkallaxes.m
%
% Olavo Badaro Marques, 05/May/2017.


%% Get number of figure handles and pre-aloocate
% cell array for axes handles:

Nfigs = length(hfigs);

haxscell = cell(1, Nfigs);


%% Loop over figures and assign axes handles to cell array:

for i = 1:Nfigs
    
   % Get all axes handles in the current figure:
    allAxes = findall(hfigs(i), 'Type', 'axes');
    onlyAxes = allAxes(~ismember(get(allAxes, 'Tag'), {'legend', 'Colobar'})); 
    
    haxscell{i} = onlyAxes;
    
end


%% Go from the cell array "haxscell" to the array of axes "allhaxs":

naxsperfig = cellfun(@length, haxscell);

% Pre-allocate space to store all axes handles:
allhaxs = gobjects(sum(naxsperfig), 1);

indi = 1;

% Loop over figures:
for i = 1:Nfigs
    
    indf = indi + naxsperfig(i) - 1;
    
    allhaxs(indi:indf) = haxscell{i};
    
    indi = indf + 1;

end


%% Link axes:

linkallaxes(axsstr, allhaxs)
function linkaxesFigs(hfigs, axsstr)
% LINKAXESFIGS(hfigs, axsstr)
%
%   inputs:
%       - hfigs: figure handles
%       - axsstr: string in the same manner as it goes into linkaxes.m
%
%
%
% Olavo Badaro Marques, 05/May/2017.


%%

Nfigs = length(hfigs);

haxscell = cell(1, Nfigs);

%%

for i = 1:Nfigs
    
   % Get all axes handles in the current figure:
    allAxes = findall(hfigs(i), 'Type', 'axes');
    onlyAxes = allAxes(~ismember(get(allAxes, 'Tag'), {'legend', 'Colobar'})); 
    
    haxscell{i} = onlyAxes;
    
end


%%

naxsperfig = cellfun(@length, haxscell);

allhaxs = gobjects(sum(naxsperfig), 1);

indi = 1;

for i = 1:Nfigs
    
    indf = indi + naxsperfig(i) - 1;
    
    allhaxs(indi:indf) = haxscell{i};
    
    indi = indf + 1;

end

%%

linkallaxes(axsstr, allhaxs)
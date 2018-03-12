function ticknmarks(xyzstr, nticks, haxs)
% TICKNMARKS(xyzstr, nticks, haxs)
%
%   inputs
%       - xyzstr:
%       - nticks:
%       - haxs (optional):
%
%
%
%
% Olavo Badaro Marques, 11/Mar/2018.


%%

if ~exist('', 'var')
    haxs = gca;
end


%%

%
tickaxsStr = cell(1, 3);

%
if ~isempty(strfind(xyzstr, 'x'))
    tickaxsStr{1} = 'x';
end

if ~isempty(strfind(xyzstr, 'y'))
    tickaxsStr{2} = 'y';
end

if ~isempty(strfind(xyzstr, 'z'))
    tickaxsStr{3} = 'z';
end

%
% % tickaxsStr = tickaxsstr(~isempty(tickaxsstr));


%%

tickaxsMap = containers.Map({'x', 'y', 'z'}, {'XTick', 'YTick', 'ZTick'});
limsaxsMap = containers.Map({'x', 'y', 'z'}, {'XLim', 'YLim', 'ZLim'});


%%

for i1 = 1:length(haxs)
    
    for i2 = 1:length(tickaxsStr)
        
        %
        axslims = get(haxs(i1), limsaxsMap(tickaxsStr{i2}));
        
        %
        set(haxs(i1), tickaxsMap(tickaxsStr{i2}), ...
                      linspace(axslims(1), axslims(2), nticks))
        
    end
    
end


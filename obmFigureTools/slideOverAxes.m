function slideOverAxes(dir2save, haxs, xlimsFrames, ylimsFrames, nameroot)
% SLIDEOVERAXES(dir2save, haxs, xlimsFrames, ylimsFrames)
%
%   inputs:
%       - dir2save:
%       - hfig:
%       - xlimsFrames:
%       - ylimsFrames (optional):
%
%
% Olavo Badaro Marques, 06/Jul/2017.


%%

hfig = get(haxs, 'Parent');


%%

if isempty(dir2save)
    lsave = false;
else
    lsave = true;
end


%%

% if lsave
%     set(gcf, 'Visible', 'off')    % I thought this could speed
%                                   % plotting the figures, but it doesn't 
% end


%%

%
if ~exist('ylimsFrames', 'var')
    ylimsFrames = ylim(haxs);
end

%
if ~exist('nameroot', 'var')
    nameroot = 'fig_';
end


%%

Nframes = size(xlimsFrames, 1);


%%

for i = 1:Nframes
    
    axis(haxs, [xlimsFrames(i, :), ylimsFrames])
    
    %%
    if lsave
        strnumFig = num2str(i);
        print(hfig, '-dpng', fullfile(dir2save, [nameroot strnumFig]))
    end
    
end




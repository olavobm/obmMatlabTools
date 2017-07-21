function slideOverAxes(dir2save, haxs, xlimsFrames, ylimsFrames, nameroot, pausetime)
% SLIDEOVERAXES(dir2save, haxs, xlimsFrames, nameroot, pausetime)
%
%   inputs:
%       - dir2save: directory to save figures (give [] to not save figures). 
%       - haxs: axes handle to slide over of.
%       - xlimsFrames: Nx2 with x limits of each of the N frames.
%       - ylimsFrames (optional): same as xlimsFrames, but for the y
%                                 values. If not given, the current values
%                                 are used for all frames.
%       - nameroot (optional): string that starts the name of all saved figures.
%       - pausetime (optional): number of seconds to pause at each frame
%                               (only when not saving figures).
%
% TO DO:
%   - Should also fix the position of other objects, specially colorbars.
%
% See also: makeSegs.m
%
% Olavo Badaro Marques, 06/Jul/2017.


%% Get the figure handle that contains the axes "haxs"

hfig = get(haxs, 'Parent');


%% Define logical variable to save figures. If dir2save
% is given as [], then do not save the figures

if isempty(dir2save)
    lsave = false;
else
    lsave = true;
end

if ~lsave
    if ~exist('pausetime', 'var')
        pausetime = 0.5;
    end
end


%% If optional inputs are not given, set default values

%
if ~exist('ylimsFrames', 'var') || isempty(ylimsFrames)
    ylimsFrames = ylim(haxs);
end

%
if ~exist('nameroot', 'var') || isempty(nameroot)
    nameroot = 'fig_';
end


%% Just a reminder of something I tried

% if lsave
%     set(gcf, 'Visible', 'off')    % I thought this could speed
%                                   % plotting the figures, but it doesn't 
% end


%% Get number of frames and set leading zeros

Nframes = size(xlimsFrames, 1);

Nframe_str = mat2str(Nframes);

str0s = ['%.' num2str(length(Nframe_str)) 'd'];


%% Get the current position of the axes

axsPos = get(haxs, 'Position');


%% Loop over frames and set the axis limits for each

for i = 1:Nframes
    
    axis(haxs, [xlimsFrames(i, :), ylimsFrames])
    
    %
    if ~isequal(axsPos, get(haxs, 'Position'))
        set(haxs, 'Position', axsPos)
    end
    
    %%
    if lsave
        strnumFig = num2str(i, str0s);
        print(hfig, '-dpng', fullfile(dir2save, [nameroot strnumFig]))
    else
        pause(pausetime)
    end
    
end




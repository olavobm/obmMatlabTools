function ezplotstruct(sv, x, y, varargin)
% ezplotstruct(sv, x, y, plotlist)
%

%%
%  inputs:
%    - sv: struct variable with different kinds of data.
%    - x: independent variable in the x axis (usually time).
%    - y: independent variable in the y axis (usually depth).
%    - varargin: name of the variables to plot. These must be fieldnames of
%                the structure "sv". The number of figures will be the same
%                as the number of inputs. You may specify one input as a
%                cell array of variables, in which case they will be
%                plotted as subplots in one figure.
%
% Function for plotting variables from the structure variable "sv". If a
% variable is a vector (matrix), then we have a 1D (2D) plot. Some
% technical detail must be taken care of here (lengths and dimension of x,
% y and the variables).....................................................
% 
% It would be nice to be able to include inputs in varargin that could be
% passed as options for the plotting functions.............................
%
% CBrewer colormap (much better than Matlab) is used through my function
% call_brewer. This is used only for diverging colormaps (i.e. velocity).
%
% BEWARE THAT DIVERGING COLORMAP IS CHOSEN IN THE CASE WHEN THERE ARE 
% POSITIVE AND NEGATIVE VALUES IN THE DATA. THAT'S KIND OF WEAK.
%
% 2D plots are made with pcolor (which makes some hidden interpolation
% and cuts the edges of the data matrix). Because of oceanographic
% applications (depth increasing downwards), axis ij is a default for 2D
% plots.
%
% APPARENTLY, THE X LABEL TIME AXIS CAN'T BE UPDATED WHEN ZOOMED IN, IN THE
% STANDARD WAY I'VE BEEN DOING, FOR WHATEVER REASON.
%
% IT WOULD BE GREAT IF WE COULD SUBSET THE DATA WHEN CALLING THE FUNCTION
% BY SIMPLY SUBSETTING THE VALUES OF THE INDEPENDENT VARIABLES
%
% SHOULD MAKE 1D PLOTS BE EITHER TIME SERIES OR VERTICAL PROFILE FORMATS!!
%
% MAKE COLORMAP SPECIFIC TO A SUBPLOT (AND A COMMENT REMARKING THIS
% DOES NOT WORK FOR OLDER MATLAB VERSIONS).
%
% LINKAXES???????????  linkaxes([hs1; hs2], 'x')??????
%
% SHOULD RETURN AXIS/SUBPLOT HANDLES FOR EASY MANIPULATION AFTERWARDS IF NECESSARY!!! 
%
% ANOTHER BORING THING WOULD BE TO ALLOW TO PLOT ON AN EXISTING
% FIGURE, IF IT IS EMPTY.
%
% A BORING BUT USEFUL THING MAY BE ALLOWING DIFFERENT SUBPLOT
% CONFIGURATIONS.
%
% SO IF I ONLY HAVE 1D DATA, THIS FUNCTION FAILS UNLESS I ADD A DUMMY
% SECOND DIMENSION?! FIX THIS!
% 
% Olavo Badaro Marques -- 12/31/2015 - created
%                         01/05/2016 - making it a general function


%% Preliminary checks and useful "parameter-variables":

N = length(varargin);
numvar = zeros(1, N);  % this will indicate the number of variables per
                       % figure and is modified in the loop below.

% Check if (or which???????) specified variables are fields of "sv":
for i1 = 1:N
    
    % We want ithvar to be a cell array, but since varargin is already a
    % cell array, we must use () or {} for one or multiple variables,
    % respectively:
    if ~iscell(varargin{i1})
        ithvar = varargin(i1);
    else
        ithvar = varargin{i1};
    end
    
    % Loop through all elements of ithvar, even though
    % length(ithvar)==1 (mostly):
    for i2 = 1:length(ithvar)
    
        % Stop running if variable not found in "sv" (at least for now):
        if ~isfield(sv, ithvar{i2})
            % Make numvar(i1) = NaN when making it possible to include
            % plotting parameters in varargin.
            error('The variable ???????? is not a field name of the structure ??????')
        else
            numvar(i1) = numvar(i1) + 1;
        end
    end 
end


%% Loop through variables and plot them in multiple figures or in different
%  subplots, depending on how the input was specified:

for i1 = 1:N
    
    % New figure:
    figure
    
    % The loop below (which is only necessary for numvar(i1)>1) is used
    % so that the plotting function can be called only once. This works
    % because subplot(1,1,1) is the same as not calling subplot. The
    % subplot handle may be used to change the colormap just for that
    % specific subplot (feature implemented in Matlab 2014b, if I'm not
    % mistaken):
    for i2 = 1:numvar(i1);
        
        % Variable to plot (varplt). It is a string:
        varset = varargin{i1};
        if iscell(varset)
            varplt = varset{i2};
        else     % in case numvar(i1)==1, varset is a string, not cell
            varplt = varset;
        end
        
        % Subplots are organized in one column:
        subpaux = subplot(numvar(i1), 1, i2);
            
        tplot = nested_ezplt(x, y, sv.(varplt));
        set_plt(tplot, varplt, subpaux)
    end
    
end


%% Nested function for plotting variables:

    function [tplot] = nested_ezplt(x, y, z)
        
        % Size of z:
        [nr, nc] = size(z);
        
        % 1D indvar:
        var1D = {x, y};
        
        % If variable is 1D, choose which one is appropriate (using length
        % only is not fully correct......................................):
        if nr==1 || nc==1
            
            if     length(z)==length(x)
                
                var1D = var1D{1};
                
            elseif length(z)==length(y)
                
                var1D = var1D{2};
                
            else
               error('Variables is 1D but length does not match with x or y') 
            end
            
            % Indicates it is a 1D plot:
            tplot = 1;
            
        else
            % Indicates it is a 2D plot:
            tplot = 2;
                
        end
        
        % Finally plot variable. Use plot if it's a 1D variable, or pcolor
        % in case it is a 2D variable:
        %
        % 1D case:
        if nr==1 || nc==1
            
            plot(var1D, z)
            
        % 2D case:
        else
            pcolor(x, y, z)
%             [~, hc] = contourf(x, y, z);
%             set(hc, 'LineStyle', 'none')
        end
        
    end

%% Nested function for setting plotting parameters:

    function set_plt(tplot, varplt, subpaux)
        
        set(gca, 'FontSize', 14)
        box on
        
        % Title:
        title(varplt, 'FontSize', 14)
        
        % 1D type of plot:
        if     tplot == 1
            grid on
            handleplt = get(gca, 'Children');
            set(handleplt, 'LineWidth', 2)
            
        % 2D type of plot:
        elseif tplot == 2
            shading flat
            axis ij
            colorbar
            
            lim_colors = caxis;
            
            % Assume that if the color limits are negative/positive,
            % then a diverging colormap, centered at 0, is appropriate:
            if lim_colors(1)<0 && lim_colors(2)>0
                
                thisclrmap = call_brewer(64);
                colormap(subpaux, thisclrmap);

                newlim = max(abs(lim_colors));
                newlim = [-newlim newlim];
                caxis(newlim)
            end
        end
        
        % Assume that if the independent variable x is very large, then
        % it is a date in Matlab format (it fails if oldest date is before
        % July 14th of 1916). Then convert it to a useful format:
        vxlims = xlim;    % limit values on x axis
        if vxlims(1)>700000
            set(gca, 'XTick', linspace(vxlims(1), vxlims(2), 7))
            set(gca, 'XTickLabel', datestr(get(gca, 'XTick'), 'dd - HH') )
        end
    end

%% Ends the main/parent function:

end



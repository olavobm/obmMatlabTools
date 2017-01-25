function [F] = obmmovies(svar)
% [F] = OBMMOVIES(svar)
%
% svar is a structure variable with the following fields:
%
%   - indvar*: independent variables that will be used for plotting each
%              frame (e.g. spatial grid of the data).
%              Vectors or matrices (IT MIGHT BE BETTER IF THEY ARE VECTORS
%              ONLY!!). * are numbers (1, 2, 3, ...) which corresponds
%              to which axes you want this variable to be on the plot.
%
% SHOULD I BE ABLE TO ZOOM IN A PARTICULAR REGION???
%
%   - datmov: data you want to make a movie of.
%   - dimmov: dimension of datmov to loop through to make the movie. 
%
% OPTIONAL FIELDS:
%
%   - timemov: independent variable ()
%   - timelims: 2-element vector with "time" bounds of the movie.
%
%   - dintitle (dinamic title): fields for doing other stuff
%
%
% Olavo Badaro Marques

%   - I MUST ADD AN OPTION TO CUSTOMIZE DIFFERENT THINGS
%   - MAYBE IF THE DATA IS A STRUCTURE, I COULD ADD ANOTHER INPUT
%     WITH THE FIELDNAMES IN THIS STRUCTURE TO MAKE A MOVIE OF POSSIBLY
%     MULTIPLE VARIABLES OOOOR, DEAL WITH VARIABLES THAT ALREADY ARE IN A
%     STRUCTURE.
%   - Figure handling


%% Get fieldnames of svar and do some checks:

svar_fields = fieldnames(svar);

% Find the positions of independent variables fields (and
% consequently how many they are):
indfd_indvar = find(strncmp('indvar', svar_fields, 6));


%% Deal with the "time" of the movie and obtain the vector indframes -- the
%  indices along the dimension dimmov of datmov for which we want to loop
%  through and make a movies:

if ~isfield(svar, 'timelims')
    
    indframes = 1:size(svar.datmov, svar.dimmov);
    
else
    
    % If timemov was not specified make a vector 1:1:end:
    if ~isfield(svar, 'timelims')
        svar.timemov = 1:size(svar.datmov, svar.dimmov);
    end
    
    % Find indices within timemov bounds that will go to the movie:
    indframes = find(svar.timemov>=svar.timelims(1) & ...
                     svar.timemov<=svar.timelims(2));
end
Nframes = length(indframes);


%% Check possible dynamic title field:

if ~isfield(svar, 'dintitle')
    svar.dintitle = cell(Nframes, 1);
else
    if ~iscell(svar.dintitle)
        svar.dintitle =  num2cell(svar.dintitle);
    end
end


%% Starts plotting (NOTE THAT WE OPEN A NEW FIGURE, WE MIGHT WANT TO CHANGE
%  THAT OR HAVE A FIELD IN THE INPUT TELLING WHAT TO DO):
%
%  Note the "standard" of making a movie in Matlab is by first making a
%  series of plot and saving the frames. That's what we do here.


% %         ind_time_plot = indframes(1);
% % 
% %         [ind_str{1:ndims(svar.datmov)}] = deal(':');
% % 
% %         ind_str{svar.dimmov} = num2str(ind_time_plot);
% % 
% %         ind_str(1:end-1) = strcat(ind_str(1:end-1), ',');
% %         ind_str{1} = ['(' ind_str{1} ];
% %         ind_str{end} = [ind_str{end} ')'];
% % 
% %         ind_str = [ind_str{:}];


temp_snapshot = dimsqueeze(svar.datmov, indframes(1), svar.dimmov);

Nindvar = length(indfd_indvar);
cellindvar = cell(1, Nindvar);
for i = 1:Nindvar
    % DO SOMETHING ABOUT ONE DIMENSIONAL PLOT -- WHETHER IT IS A TIME
    % SERIES OR A VERTICAL PROFILE!!!
    cellindvar{i} = eval(['svar.indvar' num2str(i)]);
end

% I'M ONLY TRANSPOSING BECAUSE OF THE ROMS OUTPUT. I MUST NOT DO THAT IN
% THIS FUNCTION!!!!!

% First we plot the first frame so we can fix the axis/colorbar for all
% frames that are plotted later on inside the for loop:
figure
    type_of_plot(cellindvar, 1:Nindvar, temp_snapshot')
    
%     [~, hc] = contourf(ygrid_plot, zgrid, temp_snapshot', 10:27);
    axis tight manual

%     title(timerdable(ind_time, :), 'FontSize', 14)
    title(svar.dintitle{1}, 'FontSize', 14)
    ax = gca;
    ax.NextPlot = 'replaceChildren';
    
% CAN I GETFRAME NOW SO I DON'T HAVE TO PLOT THE FIRST FRAME AGAIN???
% PROBABLY YES!!
    
F(Nframes) = struct('cdata',[],'colormap',[]);  % does it make sense???

for i = 1:Nframes
    
    temp_snapshot = dimsqueeze(svar.datmov, indframes(i), svar.dimmov);
    type_of_plot(cellindvar, 1:Nindvar, temp_snapshot')
%     title(timerdable(i, :), 'FontSize', 14)
    title(svar.dintitle{i}, 'FontSize', 14)

    drawnow
    F(i) = getframe(gcf);
    pause(1/48)
end

% Then you can replay it by doing:    movie(F, N, FPS)

end

% -------------------------------------------------------------------------
% -------------------------------------------------------------------------
% -------------------------------------------------------------------------
% END OF THE MAIN FUNCTION. Defining nested functions below:
% -------------------------------------------------------------------------
% -------------------------------------------------------------------------
% -------------------------------------------------------------------------

%% Function for squeezing an array (thedata) for a specific indice (ind)
%  in the dimension (dim):
    function [datsquzd] = dimsqueeze(thedata, ind, dim)
        % [datsquzd] = DIMSQUEEZE(thedata, ind, dim)
        %
        % Explain inputs/outputs.
        %
        % Interesting (aka ugly programming) thing I did here, BUT WOULD
        % BE AWESOME IF there is a better alternative (without the need
        % to use eval later on):
        
        % The function deal distributes inputs to outputs. In the case
        % here, we copy the string ':' to the entries of ind_srt:
        [ind_str{1:ndims(thedata)}] = deal(':');

        % Get the "slice" of the data we want (which ind along dim):
        ind_str{dim} = num2str(ind);

        % Add string ',' to some of the entries of ind_str and
        % parenthesis to the first and last such that the elements
        % of ind_str form together a string that has the form of
        % indices subsetting an array:
        ind_str(1:end-1) = strcat(ind_str(1:end-1), ',');
        ind_str{1} = ['(' ind_str{1} ];
        ind_str{end} = [ind_str{end} ')'];

        % Concatenate the elements of ind_str:
        ind_str = [ind_str{:}];
        
        % Use ind_str and squeeze to reduce the number
        % of dimensions of the data:
        datsquzd = eval(['squeeze(thedata' ind_str ')']);
    end


%% I should make my nested functions in ezplotstruct more general
%  (and in a separate file) so I could use it here as well.
% function plot_type()

    function type_of_plot(cellindvar, indvardims, thedata)
    
        N = length(cellindvar);
        
        if N==1
            
            if indvardims==1
                plot(cellindvar{1}, thedata)
            else   % indvardims==2
                plot(thedata, cellindvar{1})
            end
            
        elseif N==2
            
%             [~, hc] = contourf(cellindvar{1}, cellindvar{2}, thedata, 10:27);
%             set(hc, 'LineStyle', 'none')
            
            pcolor(cellindvar{1}, cellindvar{2}, thedata)
            shading flat
            caxis([-0.2 0.2])
            colorbar
            call_brewer(64);    
            
        end
    end




% -------------------------------------------------------------------------
% Other hints:
% I use: "h = figure('Visible','off');" to build a figure
% without display it.
% Then, I use "saveas" to save the figure as an image...
% Then, I use "im2frame" to convert the image into a movie
% frame...
% Finally, I use "movie2avi" 

% -------------------------------------------------------------------------

% % Create a VideoWriter object to write the video out to a new, different file.
% 	writerObj = VideoWriter('NewRhinos.avi');
% 	open(writerObj);
% 	
% 	% Read the frames back in from disk, and convert them to a movie.
% 	% Preallocate recalledMovie, which will be an array of structures.
% 	% First get a cell array with all the frames.
% 	allTheFrames = cell(numberOfFrames,1);
% 	allTheFrames(:) = {zeros(vidHeight, vidWidth, 3, 'uint8')};
% 	% Next get a cell array with all the colormaps.
% 	allTheColorMaps = cell(numberOfFrames,1);
% 	allTheColorMaps(:) = {zeros(256, 3)};
% 	% Now combine these to make the array of structures.
% 	recalledMovie = struct('cdata', allTheFrames, 'colormap', allTheColorMaps)
% 	for frame = 1 : numberOfFrames
% 		% Construct an output image file name.
% 		outputBaseFileName = sprintf('Frame %4.4d.png', frame);
% 		outputFullFileName = fullfile(outputFolder, outputBaseFileName);
% 		% Read the image in from disk.
% 		thisFrame = imread(outputFullFileName);
% 		% Convert the image into a "movie frame" structure.
% 		recalledMovie(frame) = im2frame(thisFrame);
% 		% Write this frame out to a new video file.
% 		writeVideo(writerObj, thisFrame);
% 	end
% 	close(writerObj);
% 	% Get rid of old image and plot.
% 	delete(hImage);
% 	delete(hPlot);
% 	% Create new axes for our movie.
% 	subplot(1, 3, 2);
% 	axis off;  % Turn off axes numbers.
% 	title('Movie recalled from disk', 'FontSize', fontSize);
% 	% Play the movie in the axes.
% 	movie(recalledMovie);
% 	% Note: if you want to display graphics or text in the overlay
% 	% as the movie plays back then you need to do it like I did at first
% 	% (at the top of this file where you extract and imshow a frame at a time.)
% 	msgbox('Done with this demo!');

% -------------------------------------------------------------------------

% % aviobj=VideoWriter(filename);
% % open(aviobj);
% % hFig=figure('Visible','Off');
% % 
% % for loop comes here
% %     cla
% % 
% %     %All Drawing stuff    
% % 
% %     img = hardcopy(hFig, '-dzbuffer', '-r0');
% %     writeVideo(aviobj, im2frame(img));
% % end
% % close(aviobj)
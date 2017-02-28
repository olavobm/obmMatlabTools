function y = sortHoop(x)
% y = SORTHOOP(x)
%
%   inputs:
%       - x: Nx2 array with subscript indices (first column for
%            row, second for column indices) defining a closed
%            circuit. All the points must be on the hoop, otherwise
%            output will not be what is expected.
%
%   outputs:
%       - y: Nx2 array with values of x sorted.
%
% SORTHOOP takes the subscript indices of the boundary of a regions
% (such as the output of findBoundary.m) and returns same indices
% but sorted in the CCW sense, starting with the elements on the
% rightmost column, among those that are in the uppermost row.
%
% SORTHOOP works by starting from a point in x and then looking
% for other points around it that are also in x. The next point
% is chosen by the first surrounding point found in a CCW
% direction, such as:
%
%       4      3      2
%       5    ptaux    1
%       6      7      8
%
% The location of the first reference point (1), to the right of
% ptaux in the example above, depends on the previous point (i.e.
% the pattern above may be rotated).
%
% This function should work as long as the input x is a closed
% loop. Beware that when a boundary makes a 90-degree corner,
% the point on the corner is NOT considered part of the loop IF
% the corner is towards the inside of the closed hoop.
%
% Olavo Badaro Marques, 21/Feb/2017.


%% Take the minimum row where values of x are
% located and the maximum column among them:

rmin = min(x(:, 1));

lrmin = (x(:, 1) == rmin);

cmaxinrmin = max(x(lrmin, 2));

lcmax = (x(:, 2) == cmaxinrmin);


%% Assign the starting point to the variable ptaux, that is
% updated in the while loop below. Also define an artificial
% direction from where we approach ptaux:

ptaux = x(lrmin & lcmax, :);

ptstart = ptaux;  % this variable is kept to know we
                  % have gone around the hoop

% Because of the definition of the starting point and the sense
% of rotation, we artificially define that we are approaching
% ptaux from the upper left. Therefore, the location (1) for
% searching neighboring points is to the left of ptaux
ptb4 = ptaux;
ptb4 = ptb4 - 1;


%% Loop over all the elements on the hoop in the CCW sense:

% Pre-allocate for the output:
y = NaN(size(x));

% Logical switch for repeating
% the loop and row index:
lloop = true;
i = 1;

while lloop    % !!! THIS SHOULD PROBABLY BE A FOR LOOP !!!
    
    % Assign current point to output variable:
    y(i, :) = ptaux;
    
    % Call nested function to get the 8 points adjacent to
    % ptaux in the appropriate order (dependent on ptb4):
    adjpts = getadjpts(ptaux, ptb4);
    
    % Get the rows in x of adjpts that are members of x:
    [~, b] = ismember(x, adjpts, 'rows');
    
    % Get the row of the first member of the above:
    c = sort(b(b>0));   % values that are not members have b==0
    c = c(1);
    
    % Assign it as the new point:
    ptnew = adjpts(c, :);  
    
    % If the new point is the starting point, update variables:
    if ~isequal(ptnew, ptstart)   % change to something else
                
        ptb4 = ptaux;
        ptaux = ptnew;
        
        i = i + 1;
        
	% Otherwise set logical switch to end the loop:
    else
        lloop = false;
    end
        
end


%% Check if any point in the input are not in the output:
if ~isempty(find(isnan(y(:, 1)), 1))
    warning('Not all input values are on the boundary.')
end


end


%% ------------------------------------------------------------
% --------------------- NESTED FUNCTIONS-----------------------
% -------------------------------------------------------------

% SHOULD EXCLUDE THE LAST ONE SO IT DOES NOT COME BACK!!

function adjpts = getadjpts(ptaux, ptb4)
    %% adjpts = GETADJPTS(ptaux, ptb4)
            %
            %   inputs:
            %       - ptaux: 
            %       - ptb4:
            %
            %   output:
            %       - adjpts: 


    adjpts = repmat(ptaux, 8, 1);
    
    %
    adjpts(1, 2) = adjpts(1, 2) + 1;
    adjpts(5, 2) = adjpts(5, 2) - 1;

    %
    adjpts(3, 1) = adjpts(3, 1) - 1;
    adjpts(7, 1) = adjpts(7, 1) + 1;

    %
    adjpts(2, 1) = adjpts(2, 1) - 1;
    adjpts(2, 2) = adjpts(2, 2) + 1;
    
    adjpts(4, 1) = adjpts(4, 1) - 1;
    adjpts(4, 2) = adjpts(4, 2) - 1;

    adjpts(6, 1) = adjpts(6, 1) + 1;
    adjpts(6, 2) = adjpts(6, 2) - 1;
    
    adjpts(8, 1) = adjpts(8, 1) + 1;
    adjpts(8, 2) = adjpts(8, 2) + 1;
    
    %
    lptb4 = (adjpts(:, 1) == ptb4(1)) & (adjpts(:, 2) == ptb4(2));
    indb4 = find(lptb4);
    
    indstartclock = rem(indb4 + 1, 8);
    
    if indstartclock==0
        indstartclock = 8;
    end
    
    indorderclock = rem(indstartclock:(indstartclock+7), 8);
    indorderclock(indorderclock == 0) = 8;
    
    adjpts = adjpts(indorderclock, :);


end


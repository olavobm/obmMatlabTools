function y = sortHoop(x)
% y = SORTHOOP(x)
%
%   inputs:
%       - x: Nx2 array with subscript indices (first column for
%            row, second for column indices) that define a closed
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
% The way SORTHOOP works, it starts from a point in x and then
% it looks for other points around it that are also in x. The
% next point is chosen by the first surrounding point found in
% a CCW direction, such as:
%
%       4      3      2
%       5    ptaux    1
%       6      7      8
%
% The location of the first reference point (1), depends on the
% previous point (i.e. the pattern above may be rotated).
%
% As long as the input is a closed loop, there 
%
% Olavo Badaro Marques, 21/Feb/2017.

% HUGE(!!!) PROBLEMS IF "TIVER UMA PENINSULA", INSTEAD OF A
% PROPER HOOP. I COULD TRY TO KEEP TRACK OF PENINSULAS!


%%

rmin = min(x(:, 1));

lrmin = (x(:, 1) == rmin);

cmaxinrmin = max(x(lrmin, 2));

lcmax = (x(:, 2) == cmaxinrmin);


%%

ptaux = x(lrmin & lcmax, :);

ptstart = ptaux;

ptb4 = ptaux;
ptb4 = ptb4 - 1;



%%

% Pre-allocate:
y = NaN(size(x));

i = 1;
%
lloop = true;

while lloop    % THIS SHOULD PROBABLY BE A FOR LOOP!
    
    y(i, :) = ptaux;
    
    adjpts = getadjpts(ptaux, ptb4);
    
    [~, b] = ismember(x, adjpts, 'rows');
    
    c = sort(b(b>0));
    c = c(1);
    
    ptnew = adjpts(c, :);  
    
    if ~isequal(ptnew, ptstart)   % change to something else
                
        ptb4 = ptaux;     % except that this is different than my initial condition
        ptaux = ptnew;
        
        i = i + 1;
        
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


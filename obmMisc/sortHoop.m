function y = sortHoop(x)
% y = SORTHOOP(x)
%
%   inputs:
%       - x: Nx2 array.
%
%   outputs:
%       - y: Nx2 array with values of x sorted.
%
%
% SORT in the CCW sense.
%
% HUGE(!!!) PROBLEMS IF "TIVER UMA PENINSULA", INSTEAD OF A PROPER HOOP.
%
%   4      3      2
%   5    ptaux    1
%   6      7      8
%
% Olavo Badaro Marques, 21/Feb/2017.


% THIS CODE IS NOT GOING TO WORK FOR CUSP BOUNDARIES,
% BUT CUSPS HAVE INTERIOR POINTS (so am I good?????)

rmin = min(x(:, 1));

lrmin = (x(:, 1) == rmin);

cmaxinrmin = max(x(lrmin, 2));


lcmax = (x(:, 2) == cmaxinrmin);
% there should be no points above this one!


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
    
    
    adjpts = getadjpts(ptaux, ptb4);
    
    [~, b] = ismember(x, adjpts, 'rows');
    
    c = sort(b(b>0));
    c = c(1);
    
    ptnew = adjpts(c, :);
    
    
    if ptnew~=ptstart
        
        y(i, :) = ptaux;
        
        ptb4 = ptaux;     % except that this is different than my initial condition
        ptaux = ptnew;
        
        i = i + 1;
        
    else
        lloop = false;
    end
        
end

keyboard


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


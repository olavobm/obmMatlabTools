function segscell = splitContinousSegs(x)
% segscell = SPLITCONTINOUSSEGS(x)
%
%   inputs:
%       - x: vector of integers in ascending order.
%
%   outputs:
%       - segscell: 1xN cell array where each element
%                   is a continuous segment of x.
%
% SPLITCONTINOUSSEGS splits the vector into its (N) continuous
% segments. Discontinuities are defined by the locations in x
% where subsequent elements differ by more than 1.
%
% Olavo Badaro Marques, 10/Mar/2017.


%% Identify discontinuities:

xdiff = diff(x);

indsplit = find(xdiff > 1);


%% Split continuous segments of x:

% Number continuous segments:
n = length(indsplit) + 1;

% Pre-allocate space for output:
segscell = cell(1, n);

% Loop over all segments and get
% the correspondent elements of x:
for i = 1:n

    % Take start index of the i'th segment:
    if i==1
        indauxstart = 1;
    else
        indauxstart = indsplit(i-1) + 1;
    end

    % Take end index of the i'th segment:
    if i<n
        indauxend = indsplit(i);
    else
        indauxend = length(x);
    end
    
    % Assign segment to output:
    segscell{i} = x(indauxstart:indauxend);
     
end


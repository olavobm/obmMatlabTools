function totalsum = addnonan(varargin)
% totalsum = ADDNONAN(varargin)
%
%   inputs
%       - varargin: double arrays with arbitrary dimensions
%                   (at least 2 inputs). All arrays must
%                   have the same dimensions.
%
%   outputs
%       - totalsum: sum of all inputs, ignoring NaNs.
%
%
% ADDNONAN.m adds all arrays given as inputs (varargin)
% ignoring all NaNs. Thus, all arrays must have the
% same size. In other words, this is similar to Matlab's
% nansum.m, except that it operates on multiple arrays
% Instead of using this function, one could also
% concatenate all arrays into a single one and then use
% nansum.m.
%
% One situation where you could use this function (or
% at least the one I had in mind when I wrote this) is
% when you have data from different sources (such as
% different instruments) on a regular grid (see
% basicgridding.m), but each data source is in a
% different region of the grid (they do NOT overlap).
% Then use ADDNONAN.m to put all gridded variables
% in a single array.
%
% This combined use of basicgridding.m/ADDNONAN.m is
% not very elegant and could be very inneficient with
% a lot of data. It would also give wrong results for
% overlapping data. However, it is a very simple approach
% and works just fine for several applications.
%
% See also: basicgridding.m.
%
% Olavo Badaro Marques, 04/Jun/2019


%%

ninputs = nargin;

%
if ninputs<2 
    error('There must be at least 2 inputs.')
end


%%

%
all_sizes = cellfun(@size, varargin, 'UniformOutput', false);

%
arraysize = all_sizes{1};

%
for i = 2:ninputs
    
    if ~isequal(arraysize, all_sizes{i})
        error('All inputs must have the same sizes.')
    end
end


%%

totalsum = NaN(arraysize);


%%

lbaddata_cell = cellfun(@isnan, varargin, 'UniformOutput', false);


%%

%
for i = 1:ninputs
    
    %
	totalsum(isnan(totalsum) & ~lbaddata_cell{i}) = 0;
    
    %
    totalsum(~lbaddata_cell{i}) = totalsum(~lbaddata_cell{i}) + ...
                                  varargin{i}(~lbaddata_cell{i});
                              
end




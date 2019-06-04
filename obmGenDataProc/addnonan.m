function totalsum = addnonan(varargin)
% totalsum = ADDNONAN(varargin)
%
%   inputs
%       - varargin:
%
%   outputs
%       - totalsum:
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
%
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




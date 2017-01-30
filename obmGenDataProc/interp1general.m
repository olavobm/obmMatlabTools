classdef interp1general
    
    properties
        xarrays
    end
    
    properties
        yarrays
    end
    
    properties
        ybase
    end
    
    methods
        
        function obj = interp1general(x, y)
            % Something to check inputs
            if nargin>=2
                obj.xarrays = x;
                obj.yarrays = y;
            end 
            
            %
            obj.ybase = cellfun(@nanmedian, obj.yarrays);
            
        end
        
        function yinterp = interpxy(obj, xi, yi)
            
            N = length(obj.xarrays);
            
            % Sort medianpres in increasing order (increasing instrument depth):
            [sortedMedian, indsort] = sort(obj.ymedian);

            % Now sort the time and pressure records:
            obj.xarrays = obj.xarrays(indsort);
            obj.yarrays = obj.yarrays(indsort);

            % 
            yonxi = NaN(N, length(xi));
            
            for i = 1:N
                yonxi(i, :) = interp1(obj.xarrays{i}, ...
                                        obj.yarrays{i}, xi);
            end
            
            
            %
            yinterp = NaN(length(yi), length(xi));
            for i = 1:length(xi)
                
                yinterp(:, i) = interp1(sortedMedian, yonxi(:, i), yi);
            end
            
        end
        
    end
    
end
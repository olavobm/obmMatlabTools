function [colsetsnew, rnansetsnew] = matchColsNanPos(x, rnansets, colsets)
%
% Olavo Badaro Marques, 21/Nov/2016.




%%


% allcols = 1:size(x, 2);

% indnan = find(isnan(x));
            
% [~, cnan] = ind2sub(size(x), indnan);
             
% cnanUniq = unique(cnan);

% cnanUniqCopy = cnanUniq;


%%
offsetcol = max([colsets{:}]);

[colsets_x, rnansets_x] = sepColsNanPos(x);

colsets_x = cellfun(@(x) x + offsetcol, colsets_x, ...
                            'UniformOutput', false);

%%

colsetsnew = colsets;
rnansetsnew = rnansets;


for i1 = 1:length(rnansets_x)
    
    for i2 = 1:length(rnansetsnew)

        isequal(rnansets_x{i1}, rnansetsnew{i2});  
        
        if isequal(rnansets_x{i1}, rnansetsnew{i2})
            
            colsetsnew{i2} = [colsetsnew{i2}, colsets_x{i1}];
            break
            
        end
        
        if i2==length(rnansetsnew)
            colsetsnew = [colsetsnew, colsets_x{i1}];
            rnansetsnew = [rnansetsnew, rnansets_x{i1}];
        end
    end
    
end






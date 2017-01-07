function StructVar = trimNaNvectors(StructVar, DimCode)
% StructVar = TRIMNANVECTORS(StructVar, DimCode)
%
%   inputs:
%       - StructVar: structure variable with fields to be trimmed. It
%                    can also be only one variable of class double, in
%                    which case, the output is of the same class.
%       - DimCode: either 1 (trim rows), 2 (columns) or 3 (both).
%
%   outputs:
%       - StructVar: StructVar with trimmed variable fields.
%
% Function TRIMNANVECTORS
% Olavo Badaro Marques, 06/Jan/2017.


%% step 3: trim column and layer that contain all NaN
if FP.trim == 1
    
    %% layers
    MEAN = [];
    for idx_var = 1 : length(FP.VarNames)
        varname = FP.VarNames{idx_var};
        data = MMP.([varname '_grid']);
        
        datamean = nanmean( data, 2);
        MEAN = [MEAN datamean(:)];
    end
    MEAN = nanmean(MEAN, 2);

    IDX_GOOD = find( ~isnan(MEAN) );    
    for idx_var = 1 : length(FP.VarNames)
        varname = FP.VarNames{idx_var};
        MMP.([varname '_grid']) = MMP.([varname '_grid'])(IDX_GOOD, :);
    end 
    MMP.('z_grid')    = MMP.('z_grid')(IDX_GOOD, :);
    

    %% columns
    MEAN = [];
    for idx_var = 1 : length(FP.VarNames)
        varname = FP.VarNames{idx_var};
        data = MMP.([varname '_grid']);
        
        datamean = nanmean( data, 1);
        MEAN = [MEAN datamean(:)];
    end
    MEAN = nanmean(MEAN, 2);

    IDX_GOOD = find( ~isnan(MEAN) );    
    for idx_var = 1 : length(FP.VarNames)
        varname = FP.VarNames{idx_var};
        MMP.([varname '_grid']) = MMP.([varname '_grid'])(:, IDX_GOOD);
    end 
    MMP.('yday_grid')    = MMP.('yday_grid')(:, IDX_GOOD);    
    
end
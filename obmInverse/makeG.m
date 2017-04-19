function G = makeG(imf, t)
% G = MAKEG(imf, t)
%
%   inputs:
%       - imf: input-model-fit structure (see myleastsqrs.m).
%       - t: independent variable of data.
%
%   outputs:
%       - G: data kernel (or Gram matrix).
%
% In standard least-squares problem, we choose models, with unknown
% model parameters "m", to fit the data "d". The problem is written
% as G*m = d and the solution is m = (G'*G) \ G'*d.
%
% MAKEG creates this matrix G. The types of models supported by this
% function are the ones in the funcFields variable and in the switch
% statement.
%
% TO DO: bring the switch statement out of the loop
%        and use an anonymous function.
%
% Olavo Badaro Marques, 18/Apr/2017.


%% Make sure t is a column vector:

t = t(:);


%% Define the types of model and how many model parameters
% each of them has. Link them through a map variable:

funcFields = {'power', 'sine', 'modelinput'};
nparFields = [1, 2, 1];

nparFields = containers.Map(funcFields, nparFields);


%%

Gfields = intersect(fieldnames(imf), funcFields, 'stable');

nfields = length(Gfields);

nmodels = NaN(nfields, 1);
npar = NaN(nfields, 1);

ncols_G = 0;

for i = 1:nfields
    
    nmodels(i) = length(imf.(Gfields{i}));
    npar(i) = nparFields(Gfields{i});
    
    ncols_G = ncols_G + (nmodels(i) .* npar(i));
    
end


%%

% We now pre-allocate space for matrix G and fill it (the index
% icf is an indicator of the column of G to be filled):
G = NaN(length(t), ncols_G);
icf = 0;

% Loop through specified model categories:
for i1 = 1:length(Gfields)

    % minfo is the vector with model parameters of the i1'th category:
    minfo = imf.(Gfields{i1});
    nloop = nmodels(i1);

    % Loop through all the models in the i1'th category:
    for i2 = 1:nloop

        % Creates 1 column of G, based on which model to fit:
        switch Gfields{i1}
            case 'power'
                cauxG = t .^ minfo(i2);

            case 'sine'
                ffac = 2*pi*minfo(i2);      % frequency factor
                cauxG = [cos(ffac.*t)  sin(ffac.*t)];

            case 'modelinput'
                cauxG = minfo{i2};                
        end

        % Indices for columns of G (npar(i1) is either 1 or 2,
        % so we are referring to either 1 or 2 columns of G):
        indcG = icf+1 : icf + npar(i1);

        % Fill matrix G:
        G(:, indcG) = cauxG;

        % Update the index icf:
        icf = icf + npar(i1);

    end
end





function [xfit, m] = myleastsqrs(t, x, imf)
% [xfit, m] = MYLEASTSQRS(t, x, imf)
%
%  inputs:
%    - t: vector with independent variable (i.e. where x is specified)
%    - x: vector with the data (dependent variable).
%    - imf: input-model-fit. Struct variable specifying models to
%                   fit (see paragraphs below for an explanation).
%
%  output:
%    - xfit: fit to the data. specified at t.
%    - m: model parameters (SHOULD THIS BE A STRUCT VARIABLE???)
%
% The function MYLEASTSQRS uses standard least squares
% to fit user-specified models to the data x, whose
% values are specified at t. NaN values in x are ignored
% (NaN in vector t will cause error).
%
% User specifies which models to fit in the input imf. This must
% be a struct variable. Fields indicate what kind of model to fit
% and each of them has a vector with paratemers for the model. "One
% parameter for each model" (always???????), therefore, the length of this vector
% is equal to the number of models of that category to fit.
%
% Talk about imf.modelinput option!!!!!!!!!! On a piece of paper I wrote:
% Since this case is intrisically user-specified, the domain will be the
% same as the data even though one might have to interpolate the model
% every time before calling this function. This emphasizes to the user what
% model you are really fitting (a discretized version of the real model).
% This is a cell array to comply with the rest of the code. If you want to
% convert a double array A, with size NxM, in a 1xM cell array (split the
% columns of A), then do mat2cell(A, N, ones(1, M)).
%
% In the case of sinusoidal fits, the fit parameter is a frequency,
% that is specified in units of the inverse of t (cyclic frequency).
% From the model weights output, the amplitude is given by
% ampl = sqrt(a^2 + b^2) and the phase by pha = atan2(b/ampl, a/ampl)
% (where pha = 0 is "regular" cosine and pha = pi/2 a sine).
%
% Writing the overdetermined (or least squares) problem as
% G*m = x, where (i) x is the data, (ii) G is a matrix whose
% columns specify the models to fit and (iii) m is a vector
% with the model parameters (amplitude/weights is somewhat
% of a better name), the best values for m, in other words,
% the ones that minimize the L2 norm of G*m - x, is given by:
%
%           m = (G' * G)^(-1) * G' * d
%
% Suggestions:
%  1 - I don't like this name for this function.
%  2 - Include comments above explaining the possible fields of imf.
%  3 - Include options for tidal frequencies (or even better,
%      make another function that gives tidal frequency in whatever units).
%  4 - Include error of the model and confidence intervals (compare with
%      Matlab's function regress).
%  5 - How to easily add models without the need of concatenating?
%  6 - Include constraints in the model.
%  7 - Make some major change such that this code can be extended or used
%      to make least squares fit in 2D/3D.
%  8 - Include something to output the residue.
%
% Olavo Badaro Marques:
%    Log -- 12/07/2015: created on this day
%           01/19/2016: option for the output be a function of a 
%                       specified independent variable in "imf"
%           09/02/2016: included an option to fit a model specified
%                       by user (e.g. vertical modes).

% WHEN DOMAIN IS SPECIFIED, DO WE USE LESS POINTS TO CONSTRUCT THE LEAST
% SQUARES???????? MAKE SURE, BUT THIS SHOULD NOT/NEVER HAPPEN!!!!!

%% We first check if the input "imf" specifies a domain where the fit will
%  be computed at. This requires another G-like matrix, which does not go
%  into the least squares fit calculation, used for computing xfit:

if isfield(imf, 'domain')
    domain = imf.domain(:);         % put in a separate column vector
    imf = rmfield(imf, 'domain');   % remove to simplify rest of the code
end


%% Make vector/struct with possible fields. This should
%  then have values associated which translate into how
%  many "parameters" for each model we need.

allfields = fieldnames(imf);  % all field names (cell array)
nfd = length(allfields);      % number of fields

% If it is a power law, only 1 parameter. Sinusoidals have 2.
npar = NaN(1, nfd);
for i = 1:nfd
    switch allfields{i}
        case 'power'
            npar(i) = 1;
        case 'sine'
            npar(i) = 2;
        case 'modelinput'
            npar(i) = 1;
    end
end
    

%% Check data, make it a column vector and
%  get where there is data (no NaNs):

% length(t)==length(x)

% Column vectors:
t = t(:);
x = x(:);

% Get locations of good data and assign to new variable:
lgd = ~isnan(x);   % logical with good data

tgd = t(lgd);   % these are the variables
xgd = x(lgd);   % the fit is based on


%% Create matrix G specifying models:

% First loop through the fields and theirs values
% to get how many models will be fit and hence
% the number of columns of matrix G:

ncols_G = 0;

for i = 1:nfd
    
    % How many models in the category allfields{i}:
%     auxlength = length(getfield(imf, allfields{i}));
    auxlength = length(imf.(allfields{i}));
    
    % Multiply to get number of necessary parameters:
    auxlength = npar(i) * auxlength;
    
    % Add up to the scalar for number of columns:
    ncols_G = ncols_G + auxlength;
    
    % In case there is a modelinput field, only keep the
    % model points in the locations where we have non-NaN data:
    if strcmp('modelinput', allfields{i})
        
        % If not all lgd elements are 1 (true):
        if ~all(lgd)
            
            % Loop through the cell array of modelinput(s) and
            % subset at the points where we have non-NaN data:
            for i2 = 1:auxlength
                
                imf.modelinput{i2} = imf.modelinput{i2}(lgd);

            end
        end 
    end
    
end

% Use the nested function defined at the end to create the matrix G for the
% locations where we have data. This matrix is used in the fit. A nested
% function was written such that it can be used again below to compute
% model fit for a domain different than that of the data (if specified
% at input):
[G] = makeG(imf, allfields, npar, ncols_G, tgd);


%% Least squares fit:

% Model parameters:
m = ( G' * G) \ ( G' * xgd);


%% Computes the curve that fits the data based on the model
% parameters m. The matrix G may be recreated to compute
% the curve at points different than just the locations
% where we have non-NaN data:

% -------------------------------------------------------------------------
% -------------------------------------------------------------------------
% IT SEEMS THE IF BELOW INSIDE THE CASE WHEN THERE IS NO DOMAIN IS USELESS!
% -------------------------------------------------------------------------
% -------------------------------------------------------------------------

% On the same location as the data (if domain not specified):
if ~exist('domain', 'var')
    
    if all(lgd)         % No NaN in the data input:
        xfit = G * m;

    else                % There are gaps in the data:
%         tnan = t;
%         tnan(~lgd) = NaN;
%         [Ggappy] = makeG(imf, allfields, npar, ncols_G, tnan); % with or
        tgp = t(lgd);
        [Ggappy] = makeG(imf, allfields, npar, ncols_G, tgp);      % without gaps
        xfit = Ggappy * m;
    end

% On the domain specified in "imf":
else
    [Gdm] = makeG(imf, allfields, npar, ncols_G, domain);   % G-domain
    xfit = Gdm * m;
end

end   % ends the main function.



%% ------------------------------------------------------------------------
% -------------------------------------------------------------------------
% ---------------------------- NESTED FUNCTION ----------------------------
% -------------------------------------------------------------------------
% -------------------------------------------------------------------------


% Function that creates the matrix G for fitting the model:
function [G] = makeG(imf, allfields, npar, ncols_G, tfit)
    % what are the inputs ??????????????????????????????????????????   

    % We now pre-allocate space for matrix G and fill it (the index
    % icf is an indicator of the column of G to be filled):
    G = NaN(length(tfit), ncols_G);
    icf = 0;

    % Loop through specified model categories:
    for i1 = 1:length(allfields)

        % minfo is the vector with model parameters of the i1'th category:
        minfo = imf.(allfields{i1});
        nloop = length(minfo);

        % Loop through all the models in the i1'th category:
        for i2 = 1:nloop

            % Creates 1 column of G, based on which model to fit:
            switch allfields{i1}
                case 'power'
                    cauxG = tfit .^ minfo(i2);

                case 'sine'
                    ffac = 2*pi*minfo(i2);      % frequency factor
                    cauxG = [cos(ffac.*tfit)  sin(ffac.*tfit)];

                case 'modelinput'
                    cauxG = minfo{i2};                
            end

            % Indices for columns of G (npar(i1) is either 1 or 2,
            % so we are referring to either 1 or 2 columns of G):
            indcG = icf+1 : icf+npar(i1);

%             try
            % Fill matrix G:
            G(:, indcG) = cauxG;
%             catch
%                 keyboard
%             end

            % Update the index icf:
            icf = icf + npar(i1);

        end
    end

end



function [pwspec] = obmPSpec(x, dt, np, ovrlap)
% [pwspec] = OBMPSPEC(x, dt, np, ovrlap)
%
%   inputs:
%       - x: vector with evenly spaced data. No NaNs allowed.
%       - dt: sampling period.
%       - np: number of data points per chunk.
%       - ovrlap: overlap between chunks (number
%                 between 0-1, default is 0.5).
%
%   output:
%       - pwspec: struct variable with power spectrum info. The fields
%                 of the structure array are:
%                       - allpsd: matrix with all power spectra,
%                                 that are averaged into psd.
%                       - psd: ensemble-averaged power spectral density.
%                       - freq: frequency vector.
%                       - dof: degrees of freedom.
%                       - err: 95% confidence interval.
%
% OBMPSPEC makes an estimate of the power spectrum using the Welch
% method, i.e. averaging the periodogram of overlapping data subsets.
% Each periodogram is computed by Matlab's fft function (the Discrete
% Fourier Transform, DFT).
%
% (even ANNNND odd length of input????)
%
% Olavo Badaro Marques, 02/Sep/2015.


%% Error message for update:

if nargin > 4
    error('I have removed useless inputs! Exclude calls for nchk and winkind.')
end


%% Check x is a column vector:

if ~isvector(x)
    error(['Input ' inputname(1) ' is not a vector. It must be.'])
else
    if ~iscolumn(x)
        x = x(:);   % transpose, with this notation, which
                    % also works if x is complex
    end
end


%% Remove continuous NaNs at the beginning and end of x only:

if isnan(x(1))
    indfirstx = find(~isnan(x), 1, 'first');
    x = x(indfirstx:end);
end

if isnan(x(end))
    indlastx = find(~isnan(x), 1, 'last');
    x = x(1:indlastx);
end


%% Length of data:
N  = length(x);

% Lowest frequency that can be resolved:
df = (1/(N*dt));

% % %% Get indices of beginning and end of each chunk - IS THIS WORTH DOING?:
% % 
% % inda = linspace(1, N, nchk+1);
% % 
% % stp = inda(2) - inda(1);
% % 
% % % Initialize chunk indices matrix:
% % chkind = NaN(nchk, 2);
% % for i = 1:nchk
% %     chkind(i, 1) = inda(i);
% %     chkind(i, 2) = inda(i+1);
% % end
% % 
% % % Approximate indices up/down:
% % chkind(:, 1) = ceil(chkind(:, 1));
% % chkind(:, 2) = floor(chkind(:, 2));


%% Determine chunks based on the user-specified number of points for
%  each chunk (this guarantees that all of them have the same length):

% Get the step for index limits of each chunk (in fact, we
% need to take the complement of the specified overlap):
novrlp = floor(np*(1-ovrlap));
   
% If user specifies a huge overlap, which might be approximated
% as 100% overlap, giving an infinite number of realizations,
% change novrlp to get the largest possible overlap:
if novrlp==0
    novrlp = 1;   % should have a different (less abitrary number)
end
    

% If there are no NaNs:
if ~any(isnan(x))
    
    % Get possible first and last indices of all chunks:
    chunk_frst_ind = 1:novrlp:N;
    chunk_last_ind = chunk_frst_ind + np - 1;

    
% But if NaNs are present, create indices iteratively
% guaranteeing there are no NaNs in any chunk:
else     
    
    chunk_frst_ind = NaN(1, length(1:novrlp:N));
    chunk_last_ind = NaN(1, length(1:novrlp:N));
    
    % 
    chunk_frst_ind(1) = 1;
    chunk_last_ind(1) = 1 + np - 1;
    
    indbegaux = 1;
    
    ind4chunk = 1;
    while (indbegaux + novrlp + np - 1)<=N
        
        indbegaux = indbegaux + novrlp;
        indendaux = indbegaux + np - 1;
        
        auxchunk = x(indbegaux:indendaux);
        
        if any(isnan(auxchunk))
            
            % Do not keep this chunk and assign a new
            % value for the first index of a chunk:
            
            auxlastNaN = find(isnan(x(1:indendaux)), 1, 'last');
            aux_first_ind = find(~isnan(x(auxlastNaN:end)), 1, 'first');
            indbegaux = auxlastNaN + aux_first_ind - 1;
            
            indbegaux = indbegaux - novrlp;
        else
            
            ind4chunk = ind4chunk + 1;
        
            chunk_frst_ind(ind4chunk) = indbegaux;
            chunk_last_ind(ind4chunk) = indendaux;  
        end
        
    end
    
    chunk_frst_ind = chunk_frst_ind(~isnan(chunk_frst_ind));
    chunk_last_ind = chunk_last_ind(~isnan(chunk_last_ind));
    
   
end


% Now get only those that don't exceed the data:
lchk = chunk_last_ind <= N;

% Subset only those chunks that can be chosen from the data:
chunk_frst_ind = chunk_frst_ind(lchk);
chunk_last_ind = chunk_last_ind(lchk);

% Get number of chunks:
nchk = length(find(lchk));


%% Now loop through all chunks and make spectral estimates:

% Lowest frequency that can be resolved at each chunk:
df = (1/(np*dt));

% Matrix for storing all spectra:
lenspec = length(2 : ceil(np/2)); % WHAT IS THIS LENGTH FOR EVEN/ODD np????
allpsd = NaN(lenspec, nchk);

% Loop through chosen chunks:
for i = 1:nchk
    
    % Subset chunks:
    xchk = x(chunk_frst_ind(i):chunk_last_ind(i));
    
    % Call nested function to compute Fourier coefficients:
    [fcoef, ~] = fftaux(xchk, np);
    
    % Choose only the appropriate coefficients
    % EACH CHUNK MUST HAVE ODD LENGTH (np MUST BE ODD!!!!!!!)
    fcoef = fcoef( 2 : ceil(np/2) );

    % Power spectrum density estimate:
    allpsd(:, i) = (2 .* (abs(fcoef).^2)) ./ (df * np^2);
    
%     % Checking variance (add xout in the output of fftaux above):
%     sample_var = var(xout);
%     integr_var = sum(allpsd(:, i) * df);
% 
%     sprintf('Variance of the data is %f and integrated spectrum is %f', ...
%                           sample_var, integr_var)

end


%% Organize structure containing spectral estimate:

% Store all individual periodograms:
pwspec.allpsd = allpsd;

% Ensemble-averaged power spectral density:
pwspec.psd = mean(allpsd, 2);

% Frequency vector:
pwspec.freq = ( 1:lenspec ) ./ (np*dt);

% Degrees of freedom - THIS NOW DEPENDS ON THE OVERLAP! I SHOULD INCLUDE
% A REFERENCE (BENDAT & PIERSOL???) FOR THE D.O.F. FORMULA:
dof = 2 * nchk;
pwspec.dof = dof;

% Error bars with 95% confidence level:
p = 0.05;
err_low  = dof / chi2inv(p/2, dof);
err_high = dof / chi2inv(1-(p/2), dof);

pwspec.err = [err_low err_high];


% -------------------------------------------------------------------------
% -------------------------------------------------------------------------
% -------------------------------------------------------------------------
%% Nested functions:

    function [fcoef, xaux] = fftaux(xaux, naux)
        % Computing Fourier coefficients via fft, but first remove
        % mean, detrend and multiply by window:
        %    - ADD INPUT SO THAT A SPECIFIED WINDOW CAN BE CHOSEN!!!):
        %    - DO I NEED NAUX AS AN INPUT (SPECIALLY WHEN CALLING FFT):
        %    - preferentially don't use Matlab's detrend function:

            % Remove the mean:
            xaux = xaux - mean(xaux);

            % Detrend the chunk:
            xaux = detrend(xaux, 'linear');

            % Multiplying chunk values by window:
            xaux = xaux .* window(@hann, naux);

            % Compute Fourier coefficients with FFT:
            fcoef = fft(xaux, naux);

        %     % If one wants to check the variance, returns modified chunk:
        %     xout = xaux;
    end

end


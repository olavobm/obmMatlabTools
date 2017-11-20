function [pwspec] = obmPSpec(x, dt, np, ovrlap)
% [pwspec] = OBMPSPEC(x, dt, np, ovrlap)
%
%   inputs:
%       - x: vector with evenly spaced data.
%       - dt: sampling period.
%       - np: number of data points per chunk.
%       - ovrlap: overlap between chunks (number
%                 between 0-1, default is 0.5).
%
%   output:
%       - pwspec: struct variable with power spectrum info. The fields
%                 of the structure array are:
%                       * allpsd: matrix with all power spectra,
%                                 that are averaged into psd.
%                       * psd: ensemble-averaged power spectral density.
%                       * freq: frequency vector.
%                       * fcoef: fourier coefficients from
%                                which allpsd are computed.
%                       * dof: degrees of freedom.
%                       * err: 95% confidence interval.
%
% OBMPSPEC makes an estimate of the power spectrum using the Welch
% method, i.e. averaging the periodogram of overlapping data subsets.
% Each periodogram is computed by Matlab's fft function (the Discrete
% Fourier Transform, DFT).
%
% The highest frequency is different whether np is even or odd. If np
% is even, max(pwspec.freq) is the Nyquist frequency, 1/(2*dt). For
% np odd, the highest frequency is a bit smaller than Nyquist, equal
% to 1/(2*dt) - (1/2)*(1/(np*dt)), which is Nyquist minus half of the
% frequency resolution.
%
% Olavo Badaro Marques, 02/Sep/2015.


%% Error message for update:

if nargin > 4
    error('I have removed unused inputs! Exclude calls for nchk and winkind.')
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


%% If ovrlap is not given, choose default value:

if ~exist('ovrlap', 'var')
    ovrlap = 0.5;
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
% df = (1/(N*dt));


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
% lenspec = length(2 : ceil(np/2)); % WHAT IS THIS LENGTH FOR EVEN/ODD np????
% allpsd = NaN(lenspec, nchk);
% allfcoefs = NaN(lenspec, nchk);

lenspec = np - 1;
allpsd = NaN(lenspec, nchk);
allfcoefs = NaN(lenspec, nchk);

% Loop through chosen chunks:
for i = 1:nchk
    
    % Subset chunks:
    xchk = x(chunk_frst_ind(i):chunk_last_ind(i));
    
    % Call nested function to compute Fourier coefficients:
    [fcoef, ~] = fftaux(xchk, np);

    % Remove Fourier coefficient of the mean:
    fcoef = fcoef(2:end);
    
    fcoef = fcoef .* sqrt(np/(sum(window(@hann, np).^2)));
    
    % Power spectrum density estimate:
    allpsd(:, i) = (abs(fcoef).^2) ./ (df * np^2);

    % Normalize to account by variance reduction from Hanning window:
%     allpsd(:, i) = allpsd(:, i) .* (np/(sum(window(@hann, np).^2)));
    % or should I normalize the fourier coefficients such that
    % cross-Spectral analysis take the variance preserving coefficients????
    
    % Assign fourier coefficients to variable to in the output:
    allfcoefs(:, i) = fcoef;
    
%     % Checking variance (add xout in the output of fftaux above):
%     sample_var = var(detrend(xchk, 'linear'));
% %     sample_var = var(xout);   % this has been windowed, so the
%                                 % variance won't match
%     integr_var = sum(allpsd(:, i) * df);
% 
%     sprintf('Variance of the data is %f and integrated spectrum is %f', ...
%                           sample_var, integr_var)
                      
end


%%

nyquistFreq = 1/(2*dt);    % == floor(np/2)/(np*dt) if np is even

% Frequency vector:

% Frequency vector -- from fundamental to highest:
pwspec.freq = (1:floor(np/2)) ./ (np*dt);

% Replicate and create negative frequencies:
pwspec.freq = [pwspec.freq, -fliplr(pwspec.freq(pwspec.freq < nyquistFreq))];

% THERE IS A COMPARISON WITH THE NYQUIST FREQUENCY, SHOULD I INCLUDE AN
% APPROXIMATION????

%
indneg = find(pwspec.freq < 0);
if isreal(x)

    % fold negative-frequency part onto positive side:
    allpsd(1:length(indneg), :) = allpsd(1:length(indneg), :) + ...
                                                flipud(allpsd(indneg, :));  
	allpsd = allpsd(1:(indneg(1)-1), :);
           
    allfcoefs = allfcoefs(1:(indneg(1)-1), :);
    
    pwspec.freq = pwspec.freq(1:(indneg(1)-1));
    
else
    
    % complex
    allpsd = [allpsd(indneg, :); allpsd(1:(indneg(1)-1), :)];
    
    allfcoefs = [allfcoefs(indneg, :); allfcoefs(1:(indneg(1)-1), :)];
    
    pwspec.freq = [pwspec.freq(indneg), pwspec.freq(1:(indneg(1)-1))];
    
end


%% Organize output structure:

% Store all individual periodograms:
pwspec.allpsd = allpsd;

% Ensemble-averaged power spectral density:
pwspec.psd = mean(allpsd, 2);

% Fourier coefficients:
pwspec.fcoef = allfcoefs;

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
        % [fcoef, xaux] = FFTAUX(xaux, naux)
        %
        %   inputs:
        %       - xaux: 1xnaux (row) vector.
        %       - naux: PROBABLY UNNECESSARY!!!
        %
        %   outputs:
        %       - fcoef: Fourier coefficients
        %       - xaux: demeaned-detrend-windowed xaux.
        %
        % Computing Fourier coefficients via fft, but first remove
        % mean, detrend and multiply by window:
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


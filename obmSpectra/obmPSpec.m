function [pwspec] = obmPSpec(x, dt, np, nchk, ovrlap, winkind)
% [pwspec] = obmPSpec(x, dt, np, nchk, ovrlap, winkind)
%
%  inputs:
%    - x: vector with evenly spaced data. No NaNs allowed.
%    - dt: sampling period.
%    - np: number of data points per chunk.
%    - nchk: number of chuncks to chop the data.
%    - ovrlap: overlap between chuncks (number between 0-1, default is 0.5).
%    - winkind: string with the kind of window you want.
%
%  output:
%    - pwspec: struct variable with computed power spectrum. Fields are
%              the power spectrum density and the associated frequency
%              vector.
%
% OBMPSPEC makes an estimate of the power spectrum using the Welch
% method, i.e. averaging the periodogram of overlapping data subsets.
% Each periodogram is computed by Matlab's fft function (the Discrete
% Fourier Transform, DFT).
%
% Organization of Fourier Coefficients by Matlab's FFT???
% (even ANNNND odd length of input????)
%
% MAKE SURE INPUT x is column vector-like.
%
% MAKE THIS NOTE BELOW (this is an example from Ian's routine)
% Note: Spectrum has max period of record length and min
%       (Nyquist) period of twice the sampling interval.
%
% Olavo Badaro Marques, 02/Sep/2015.


% TEST INPUT ARGUMENT, IF IT IS A VECTOR, MAKE SURE IT IS A COLUMN
% INCLUDE IN THE FINAL STRUCTURE ONE FIELD WITH, RESOLUTION


%% Length of data:
N  = length(x);

% Lowest frequency that can be resolved:
df = (1/(N*dt));

% % %% Get indices of beginning and end of each chunck - IS THIS WORTH DOING?:
% % 
% % inda = linspace(1, N, nchk+1);
% % 
% % stp = inda(2) - inda(1);
% % 
% % % Initialize chunck indices matrix:
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
    novrlp = 1;
end
    
% Get possible first and last indices of all chunks:
chunk_frst_ind = 1:novrlp:N;
chunk_last_ind = chunk_frst_ind + np - 1;

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

% Loop through chosen chuncks:
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
%% Additional functions:

    function [fcoef, xaux] = fftaux(xaux, naux)
        % Computing Fourier coefficients via fft, but first remove
        % mean, detrend and multiply by window:
        %    - ADD INPUT SO THAT A SPECIFIED WINDOW CAN BE CHOSEN!!!):
        %    - DO I NEED NAUX AS AN INPUT (SPECIALLY WHEN CALLING FFT):
        %    - preferentially don't use Matlab's detrend function:

            % Remove the mean:
            xaux = xaux - mean(xaux);

            % Detrend the chunck:
            xaux = detrend(xaux, 'linear');

            % Multiplying chunck values by window:
            xaux = xaux .* window(@hann, naux);

            % Compute Fourier coefficients with FFT:
            fcoef = fft(xaux, naux);

        %     % If one wants to check the variance, returns modified chunk:
        %     xout = xaux;
    end

end


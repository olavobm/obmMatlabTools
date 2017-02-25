function [intSpec, actualdf] = integrateSpec(pwspec, df, lsumrot)
% [intSpec] = INTEGRATESPEC(pwspec, df, lsumrot)
%
%   inputs:
%       - pwspec: structure with (at least) 2 fields -- psd
%                 (power spectral density) and freq
%                 (frequency vector).
%       - df: Nx2 matrix with N bandwidths to integrate the spectrum.
%       - lsumrot (optional): logical variable -- true if you want to add
%                             the integrals in the negative and positive
%                             parts of the spectrum (default is false);
%
%   outputs:
%       - intSpec: Nx1 array with N integrals of the spectrum over
%                  the bandwidth(s) df.
%       - actualdf:
%
% INTEGRATESPEC integrates a spectrum over frequency band(s) specified
% by df.
%
% In fact, df is also optional (even though this function can be ). If
% not specified, the integral is taken over all frequencies.
%
% Olavo Badaro Marques, 23/Feb/2017.


%% Relevant fields:

psd = 'psd';
freq = 'freq';


%% Check optional input:

if ~exist('lsumrot', 'var')
    lsumrot = false;
end


%%

if (min(pwspec.(freq)) < 0) && (max(pwspec.(freq)) > 0)
    lnegpos = true;
else
    lnegpos = false;
end


if ~exist('df', 'var') || isempty(df)
    
    if min(pwspec.(freq)) <= 0   % maybe the next code block
                                 % mayde this if useless
        
        indneg = find(pwspec.(freq) < 0);
        indpos = find(pwspec.(freq) > 0);
        
        df = [min(pwspec.(freq)(indneg)), max(pwspec.(freq)(indneg)) ; ...
              min(pwspec.(freq)(indpos)), max(pwspec.(freq)(indpos)) ];
    else
        df = [min(pwspec.(freq)), max(pwspec.(freq))];
    end
    
    
end


%%

if lnegpos && lsumrot
    
    negdf = - [df(:, 2), df(:, 1)];
    
    df = [df; negdf];
    
end


%% Loop over frequency bands and integrate spectrum:

nints = size(df, 1);

% Pre-allocate space for output:
intSpec = NaN(nints, 1);

% Loop over intervals to integrate:
for i = 1:nints
    
    % Find closest values (SHOULD I JUST INTERPOLATE - ?):
    inddf = dsearchn(pwspec.(freq)', df(i, :)');
    
%     % ------------------------------------------------
%     % interpolate spectrum:
%     % this is likely fine, but might be too handy, which
%     % could confuse the user
%     specends = interp1(pwspec.(freq), log10(pwspec.(psd)), df(i, :));
%     
%     % find the locations to insert the values
%     df(i, 1) > pwspec.(freq)
%     df(i, 1) < pwspec.(freq)
%     
%     df(i, 2) > pwspec.(freq)
%     df(i, 2) < pwspec.(freq)
%     pwspec.
%     % ------------------------------------------------
    
    intSpec(i) = trapz(pwspec.(freq)(inddf(1):inddf(2)), ...
                       pwspec.(psd)(inddf(1):inddf(2)));
    
	% I've seen a weird bug (?) with trapz
    % Error using permute. ORDER contains an invalid permutation index.
end


%%

if lsumrot
    
    intSpec = intSpec(1:(end/2)) + intSpec(((end/2)+1):end);
    
end

function [xfilt, metafilt] = bandPassFilter(dt, x, cfreq, bndw, nord)
% [xfilt, metafilt] = BANDPASSFILTER(dt, x, cfreq, bndw, nord)
%
%   inputs
%       - dt: sampling interval.
%       - x: vector with the signal.
%       - cfreq:
%       - bndw: bandwidth.
%       - nord: order of the filter.
%
%   outputs
%       - xfilt: filtered signal
%       - metafilt: metadata with the filter information.
%
% BANDPASSFILTER band-pass filter the signal "x" with a bandwidth "bndw"
% around the frequency "cfreq". A butterworth filter of order "nord"
% is used.
%
%
% Olavo Badaro Marques, 14/Sep/2017.


%% THINGS TO DO TO MAKE THIS FUNCTION RIGHT (Getting there)

% 1 - See what should be the phase of the filter phase. When
%     the filter magnitude is zero, the phase goes to pi/2.
%
% 2 - Check how to apply filter twice and how to obtain the
%     final filter response function.
%
% 3 - Compare with results from filtfilt.m


%% Making sure datain has the right dimensions:
% % 
% % [rdat, cdat] = size(datain);
% % 
% % % If datain is a column vector, make it a row vector:
% % if rdat>1 && cdat==1
% %     datain = datain';
% %     [rdat, cdat] = size(datain);
% % end


%%

N = length(x);


%% Form the filter parameters (a, b) and the frequency responce function

samplefreq  = 1/dt;
nyquistfreq = samplefreq/2;

%
fc1 = cfreq * (1 - (bndw/2));
fc2 = cfreq * (1 + (bndw/2));

% Compute parameters for a butterworth filter
[b, a] = butter(nord, [fc1/nyquistfreq, fc2/nyquistfreq]);

% % % Low-pass filter:
% % [bl, al] = butter(5, 0.3, 'low');

[Hl, bla] = freqz(b, a, floor(N/2)+1, 1/dt);  % N is the length of the time series

%  + 1 to floor() gives bla which is equal to the frequency vector, however
%  the frequency response function looks a bit funky

% % % % This might be helpful, though I would like to do it on my own
% % % 
% % % [H,F] = freqz(...,N,Fs) and [H,F] = freqz(...,N,'whole',Fs) return
% % %     frequency vector F (in Hz), where Fs is the sampling frequency (in Hz).

%
% % xl = 0 : (1/(N/2 -1)) : 1;

%% Frequency vector -- from fundamental to highest:

freqvec = (0:floor(N/2)) ./ (N*dt);


%% Duplicate response function (for negative
% frequencies) to match fft of the data

% % % % % if Hl is odd (x is even)
if rem(length(x), 2) ~= 0
    indstopA = length(Hl);
    indstopB = indstopA;
else
    indstopA = length(Hl);
    indstopB = length(Hl) - 1;
end

fRep = [flipud(Hl(2:indstopA)); Hl(1:indstopB)];


%% Now take the fft of x

xfft = fft(x);

xfft_shifted = fftshift(xfft);


%% Multiply fft by the response function


filt_fft = xfft_shifted .* fRep;



%%
 
figure
    subplot(2, 1, 1); plot(abs(xfft_shifted))
	subplot(2, 1, 2); plot(abs(fRep))
    linkallaxes('x')
    xlim([4970, 5030])
    apply2allaxes(gcf, {'FontSize', 14, 'XGrid', 'on', 'YGrid', 'on'})
   
    
%% Plot the positive frequency part only

% Should merge the two figures below into one

%
figure
    subplot(2, 1, 1); plot(freqvec(1:100), abs(xfft(1:100)), 'LineWidth', 2)
	subplot(2, 1, 2); plot(bla(1:100), abs(Hl(1:100)), 'LineWidth', 2)
    linkallaxes('x')
    apply2allaxes(gcf, {'FontSize', 14, 'XGrid', 'on', 'YGrid', 'on'})

    
%
N = length(x);
N = N/2;
newFigDims([8.2222, 6.6528])
    subplot(2, 1, 1); semilogx(abs(xfft_shifted(N:end)), 'LineWidth', 2)
	subplot(2, 1, 2); semilogx(abs(fRep(N:end)), 'LineWidth', 2)
    
    %
    apply2allaxes(gcf, {'FontSize', 14, 'XGrid', 'on', 'YGrid', 'on'})
    linkallaxes('x')
    xlim([1 400])
    titleAll({'Signal''s power spectrum', ...
              'Filter''s frequency response function'}, ...
              [], 'FontSize', 24, 'Interpreter', 'Latex')


%% Inverse fft the result

filt_fft_unshifted = ifftshift(filt_fft);

xfilt = ifft(filt_fft_unshifted, 'symmetric');


%%

figure
    subplot(2, 1, 1); plot(x)
    subplot(2, 1, 2); plot(xfilt)
    %
    apply2allaxes(gcf, {'FontSize', 14, 'XGrid', 'on', 'YGrid', 'on'})
    linkallaxes('x')
    

%% Assign output variables

metafilt.freq = freqvec;
metafilt.freq = Hl;

% should also include numbers for the cut-off frequency,
% band-width, filter order and string for type of filter
% (see Matlab's designfilt.m)
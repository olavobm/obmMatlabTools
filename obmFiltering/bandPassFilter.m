function xfilt = bandPassFilter(dt, x, cfreq, bndw, nord)
% xfilt = BANDPASSFILTER(dt, x, cfreq, bndw, nord)
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
%
%
%
%
% Olavo Badaro Marques, 14/Sep/2017.


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

% Create frequecy response function of the desired filter. This
% is a complex function, such that it modifies the amplitude
% and phase of the signal.
[Hl, ~] = freqz(b, a, floor(N/2));  % N is the length of the time series
xl = 0 : (1/(N/2 -1)) : 1;


%% Now take the fft of x

xfft = fft(x);

bla = fftshift(xfft);

%
ble = obmPSpec(x, dt, N);

%%

newFigDims([14.4, 12.74])

    subplot(4, 1, 1)
        semilogy(xl, abs(xfft(1:(N/2))))
        ylabel('FFT magnitude')
    
	subplot(4, 1, 2)
        semilogx(fourier(dt, N-1)./(2*pi), abs(xfft(1:(N/2))))
        ylabel('FFT magnitude')
        
    subplot(4, 1, 3)
        semilogx(fourier(dt, N-1)./(2*pi), abs(Hl), 'r')
        ylabel('Gain [unitless]')

	subplot(4, 1, 4)
        semilogy(xl, abs(Hl), 'r')
        xlabel('Normalized frequency [\pi radians per sample]')
        ylabel('Gain [unitless]')
        
	%
	apply2allaxes(gcf, {'FontSize', 14, 'XGrid', 'on', ...
                        'YGrid', 'on'})
    





%% Normalize the fft by the response function


%% Inverse fft the result


%% Assign output variables

function yfilt = bandPassFilter(dt, x, cfreq, bndw, nord)
% yfilt = BANDPASSFILTER(x, y, fs, nord)
%
%   inputs
%       - dt:
%       - x:
%       - cfreq:
%       - bndw:
%       - nord:
%
%   outputs
%       - yfilt:
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

%% Form the filter parameters (a, b):

samplefreq  = 1/dt;
nyquistfreq = samplefreq/2;

%
fc1 = cfreq * (1-bandwfilter/2);
fc2 = cfreq * (1+bandwfilter/2);

% Compute parameters for a butterworth filter
[b, a] = butter(butterorder, [fc1/nyquistfreq, fc2/nyquistfreq]);


% % % Low-pass filter:
% % [bl, al] = butter(5, 0.3, 'low');

% Create frequecy response function of the desired filter. This
% is a complex function, such that it modifies the amplitude
% and phase of the signal.
[Hl, ~] = freqz(b, a, floor(N/2));  % N is the length of the time series
xl = 0 : (1/(N/2 -1)) : 1;


%%

figure(1)
    hold on, box on, grid on
    plot(xl, abs(Hl), 'r')
    xlabel('Normalized frequency [\pi radians per sample]', 'FontSize',14)
    ylabel('Gain [unitless]', 'FontSize', 14)
    set(gca, 'FontSize', 14)
    ylim([-0.1 1.1])


%% Now take the fft of x

xfft = fft(x);

bla = fftshift(xfft);


%% Normalize the fft by the response function


%% Inverse fft the result


%% Assign output variables

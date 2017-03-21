function skill = skillHarmSinFit(t, x, freq)
% skill = SKILLHARMSINFIT(t, x, freq)
%
%   inputs:
%       - t:
%       - x:
%       - freq:
%
%   outputs:
%       - skill:
%
%
%
%
% Olavo Badaro Marques, 20/Mar/2017.



%%

imf.power = [0, 1];
imf.sine = freq;

[dnew, xnew] = sliding_harmonicfit(t, x, wnd, slidestep, imf);

%%


y = dnew;


%%

skill = skillpar(x, y);
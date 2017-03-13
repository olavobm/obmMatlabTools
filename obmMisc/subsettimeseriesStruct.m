function [xout] = subsettimeseriesStruct(x, varfields, d, dlims, t, tavgstep)
% [xout] = SUBSETTIMESERIESSTRUCT(x, varfields, d, dlims, t, tavgstep)
%
%   inputs:
%       - x:
%       - varfields:
%       - d:
%       - dlims:
%       - t:
%       - tavgstep:
%
%
%   outputs:
%       - xout:
%
%
%
% Olavo Badaro Marques, 13/Mar/2017.


%%



indcell = 

indvarlims = dlims;

varcell = 

structout = subsetStruct(indvarcell, indvarlims, structvar, varcell);


%%

% For simplicity, subset the data for when McLane profiled correctly:
% ydaysubset = [25 60];
ydaysubset = [15 60];
MPsub = MP109.aqdp;
linsubset = MPsub.yday>=ydaysubset(1) & MPsub.yday<=ydaysubset(2);
MPsub.yday = MPsub.yday(linsubset);
MPsub.p = MPsub.p(linsubset);
MPsub.u = MPsub.u(linsubset);
MPsub.v = MPsub.v(linsubset);
MPsub.w = MPsub.w(linsubset);
MPsub.pitch = MPsub.pitch(linsubset);
MPsub.roll = MPsub.roll(linsubset);

MPnearbot = MPsub;
lnearbot = MPnearbot.p>=1643 & MPnearbot.p<=1653;
MPnearbot.yday = MPnearbot.yday(lnearbot);
MPnearbot.u = MPnearbot.u(lnearbot);
MPnearbot.v = MPnearbot.v(lnearbot);
MPnearbot.w = MPnearbot.w(lnearbot);
MPnearbot.p = MPnearbot.p(lnearbot);
MPnearbot.pitch = MPnearbot.pitch(lnearbot);
MPnearbot.roll = MPnearbot.roll(lnearbot);

    
% Take the time difference. When it goes to another profile,
% there is a difference of 15 to 40 minutes:
lsameprof = (diff(MPnearbot.yday)*24*60) < 1;

inddiffprof = find(~lsameprof);
ndiffprof = length(inddiffprof);

indall = length(MPnearbot.yday);

% Pre-allocate:
MPbotavg.yday = NaN(1, ndiffprof);
MPbotavg.u = NaN(1, ndiffprof);
MPbotavg.v = NaN(1, ndiffprof);
MPbotavg.w = NaN(1, ndiffprof);
MPbotavg.p = NaN(1, ndiffprof);
MPbotavg.pitch = NaN(1, ndiffprof);
MPbotavg.roll = NaN(1, ndiffprof);

%
avgfields = fieldnames(MPbotavg);

indbeg = 1;

% Loop through profiles and take the average:
for i1 = 1:ndiffprof
    
    
    indend = inddiffprof(i1);
    
    indavg = indbeg : indend;
    
    for i2 = 1:length(avgfields)
        MPbotavg.(avgfields{i2})(i1) = mean(MPnearbot.(avgfields{i2})(indavg));
    end
   
    if (MPnearbot.yday(indend)-MPnearbot.yday(indbeg)*24*60)>1
        warning('!!!')
    end
    
    % Update indice:
    indbeg = indend + 1;
    
end
function [varhigh, varlow] = highpassBinAvg(t, x, binlen, tbin)
% [varhigh, varlow] = HIGHPASSBINAVG(t, x, binlen, tbin)
%
%   inputs
%       - t: 
%       - x: 
%       - binlen:
%       - tbin (optional): but it is often recommended/required.
%
%   outputs
%       - varhigh:
%       - varlow:
%
%
% Olavo Badaro Marques, 03/August/2018.


%%

if ~exist('tbin', 'var')
	tbin = t(1) : (binlen/2) : t(end);
end


%%
%
varlow = obmBinAvg(t, x, binlen, tbin, @rectwin);

%
if ~isvector(varlow)
	varlow = varlow.';
end

varlow_interp = interp1overnans(tbin, varlow, t);

if ~isvector(varlow)
	varlow_interp = varlow_interp.';
%     varlow = varlow.';
end

%
varlow = varlow_interp;

%%
varhigh = x - varlow_interp;


function [phaseerr, phase_simul] = MonteCarlo_phaseerr(x, y, xerr, yerr, Nrep)
% [phaseerr, phase_simul] = MONTECARLO_PHASEERR(x, y, xerr, yerr, Nrep)
%
%   inputs
%       - x:
%       - y:
%       - xerr:
%       - yerr:
%       - Nrep:
%
%   outputs
%       - phaseerr:
%
%
% To do:
%   - Before this function, can I shift away from 0?
%
% Olavo Badaro Marques, 12/Feb/2019.

%
x_rand_error = xerr .* randn(Nrep, 1);
y_rand_error = yerr .* randn(Nrep, 1);

%
x_simul = x + x_rand_error;
y_simul = y + y_rand_error;

%
phase_simul = atan2(y_simul, x_simul);

%
phaseerr = std(phase_simul);
function squareScatter(x, y, margfac, lcut)
% SQUARESCATTER(x, y, margfac, lcut)
%
%   inputs:
%       -
%       -
%       -
%       -
%
%
%
%
% Olavo Badaro Marques, 16/Mar/2017.

indplt = 700;

p1 = [aqdp.u(indplt), aqdp.v(indplt), aqdp.w(indplt)];
p2 = [aqdp.u(indplt+1), aqdp.v(indplt+1), aqdp.w(indplt+1)];

maxx = max([abs(p1(1)), abs(p2(1))]);
maxy = max([abs(p1(2)), abs(p2(2))]);

maxaxs = max([maxx, maxy]);
marfac = 0.1;

vecaxslims = [-1 1 -1 1] .* maxaxs * (1+marfac);

figure
    plot(p1(1), p1(2), '.', 'MarkerSize', 24)
    hold on
    plot(p2(1), p2(2), '.', 'MarkerSize', 24)
    axis equal
    grid on
    axis(vecaxslims)
    
    xtickslen = length(get(gca, 'XTick'));
    ytickslen = length(get(gca, 'YTick'));
    
    if xtickslen > ytickslen
        
        set(gca, 'YTick', get(gca, 'XTick'))
        
    elseif xtickslen < ytickslen
        set(gca, 'XTick', get(gca, 'YTick'))
    end
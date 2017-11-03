function haxs = plotXYpanels(t, x, y, tlims, xyaxslims, indz, haxs)
% PLOTUVPANELS(t, x, y, tlims, indz, haxs)
%
%   inputs
%       -
%       -
%       -
%       -
%       -
%       - indz (optional):
%       - haxs (optional):
%
%   outputs
%       - haxs: axes handles (which are created if creating a new figure).
%
% TO DO:
%   - fix indexing when there are multiple rows.
%
% Olavo Badaro Marques, 30/Oct/2017.


%%

if ~exist('haxs', 'var')
    lnewFig = true;
else
    lnewFig = false;
end

if ~exist('indz', 'var') || isempty(indz)
	indz = 1;
end


%%

%
if isvector(tlims)
    if length(tlims)>2
        tlims = [tlims(1:end-1)', tlims(2:end)'];
    end
end

%    
Ncpan = size(tlims, 1);
    
%
Nrpan = length(indz);

if Nrpan==1
    indz = repmat(indz, 1, Ncpan);
end


%%


if lnewFig
    figure
%     newFigDims([24.5278, 5.5833])
        haxs = symSubArray([0.05 0.1], [0.03 0.1], [Nrpan, Ncpan]);
end


%%

for i1 = 1:length(haxs)
    
    %
    lintlim = (t >= tlims(i1, 1)) & (t <= tlims(i1, 2));
    
    %
    plot(haxs(i1), x(indz(i1), lintlim), y(indz(i1), lintlim))    
    
    %
%     axis(haxs(i1), 'equal')
    axis(haxs(i1), xyaxslims)
    
end

    %
    apply2allaxes(gcf, {'FontSize', 14, 'XGrid', 'on', 'YGrid', 'on'})
    rmTickLabels


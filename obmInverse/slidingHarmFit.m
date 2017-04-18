function [dfit, mfit] = slidingHarmFit(x, d, xfit, wnd, imf, lpartfit, minptsfit)
%
%
%   inputs:
%       - x: vector or matriz consistent with the columns of d
%       - d:
%       - xfit: must be a vector.
%       - wnd:
%       - imf:
%       - lpartfit:
%       - minptsfit:
%
%   outputs:
%       - dfit:
%       - mfit:
%
% TO REPLACE sliding_harmonicfit.m
%
% Olavo Badaro Marques, 18/Apr/2017.


%%

if ~exist('minptsfit', 'var')
    minptsfit = 0;
end


%% Take the window half length (which is the variable
% that is used below) and define ??????????????????:

halfwnd = wnd/2;

if isvector(x)
    
    xn = 1;
    dn = size(d, 1);
    
    if iscolumn(x)
        x = x';
    end
    
else
    
    xn = size(x, 1);
    dn = 1;
    
end


%% Pre-allocate:

dfit = NaN(size(d, 1), length(xfit));

mfit = cell(size(d, 1), length(xfit));


%%

% Loop through the levels with different x vectors
% (greater than 1, only if x is a matrix):
for i1 = 1:xn
    
    % Get the i1th row of x:
    xaux = x(i1, :);
    
    % 
    
    % Loop through the points where we estimate fits (points of xfit):
    for i2 = 1:length(xfit)
        
        linWindow = (xaux >= (xfit(i2) - halfwnd)) & ...    % this selection already
                    (xaux <= (xfit(i2) + halfwnd));         % excludes NaN in xaux! Cool!
                                                                          
        
        imf.domain = xfit(i2);
        
        % Loop through the rows of d that have same x, which is all of
        % them if x is a vector or only one row if x is a matrix:
        for i3 = 1:dn
            
            dwndaux = d(i3 + i1-1, linWindow);

            if length(find(~isnan(dwndaux))) >= minptsfit
            
                [fit_aux, m_aux, G_aux] = myleastsqrs(xaux(linWindow), dwndaux, imf);
                if exist('lpartfit', 'var')
                    fit_aux = partialFit(lpartfit, m_aux, G_aux);
                end

                % Assign fitted value to output in the appropriate location:
                dfit(i3 + i1-1, i2) = fit_aux;

                mfit{i3 + i1-1, i2} = m_aux;
            end
        end
        
        
    end
    

% %     % Look at first and last indices in order to include a timer
% %     % inside the loop (to print on the screeen message of how long
% %     % it is going to take):
% %     nindstots = indlastx - indfirstx + 1;
% % 
% % 
% % %     disp(['On window center ' num2str(xwndcenteraux) ', last is ' num2str(xwndclast) ''])
% % 
% % %         % Print message to the screen of how long it is going to take:
% % % %         if rem(i1, round(0.2*xn)) == 0
% % % %             if rem(indwndcenteraux - indfirstx, round(0.25 * nindstots))==0
% % % %                 disp(['At row ' num2str(i1) ' of ' num2str(xn) ', ' ...
% % % %                       'doing window ' ...
% % % %                       num2str(indwndcenteraux - indfirstx) ' of ' ...
% % % %                       num2str(nindstots) ''])
% % % %             end
% % % %         end

end


function dispforProgress(indd, minmaxinds, msgstep, msgcode)
%
%
%   inputs:
%       - indd: iteration dummy index.
%       - minmaxinds: 1x2 vector with the first and
%                     last indices of the loop.
%       - msgstep: display message step.
%       - msgcode: number for what type of message to display
%                  (see the switch code block below).
%
% Olavo Badaro Marques, 18/Apr/2017.


%% Just split minmaxinds into 2 inputs for clarity:

indstart = minmaxinds(1);
indend = minmaxinds(2);


%%

switch msgcode
    
    case 1
    
        msgProgress = 'Done with %d out of %d';
        msgVars = [indd, indend];
        
        indClock = msgstep;
        
	case 2
        
        inddFrac = round(100 * (indd-indstart+1) / (indend-indstart+1));
        
        msgProgress = 'Done with %.0f%%';
        msgVars = inddFrac;
        
        indClock = round(msgstep*(indend-indstart+1));
        
end


%% Print message on the screen:

if rem((indd - indstart + 1), indClock)==0
    
    sprintf(msgProgress, msgVars)
    
end






function tsplit = split_sequence_gaps_refs(trefs, gapth, tvec)
% tsplit = SPLIT_SEQUENCE_GAPS_REFS(trefs, gapth, tvec)
%
%   inputs
%       - trefs: Nx2 double array.
%       - gapth:
%       - tvec:
%
%   outputs
%       - tsplit: 1xN structure array with the
%                 following fields:
%                       * t:
%                       * tref:
%                       * indsub: 1x2
%
%
% Olavo Badaro Marques, 24/May/2019.


%%

N = size(trefs, 1);


%%

tsplit = createEmptyStruct({'t', 'tref', 'indsub'}, N);


%%

tmid = (tvec(1:end-1) + tvec(2:end))./2;
tvec_diff = diff(tvec);

inds_beg = 1:(length(tvec)-1);
inds_end = 2:length(tvec);


%%

%
lyesgap = tvec_diff > gapth;
lnogap = ~lyesgap;

%
ind_gap_tdiff = find(lyesgap);

%
for i = 1:N
    
    %
    if any(tvec >= trefs(i, 1) & tvec <= trefs(i, 2));
    
        % -----------------------------------------------------------------
        % Edge 1 / left edge
        if trefs(i, 1) <= tvec(1)

            indbeg_aux = inds_beg(find(lnogap, 1, 'first'));

        else

            %
            lmatch = tvec==trefs(i, 1);

            if ~any(lmatch)
                indsbound_aux = [find(tvec < trefs(i, 1), 1, 'last'), ...
                                 find(tvec > trefs(i, 1), 1, 'first')];
            else
                % Most likely
                indsbound_aux = [find(lmatch), find(lmatch)];
            end

            %
            inddiff_first_after_aux = find(inds_beg==indsbound_aux(1));
            inddiff_last_before_aux = find(inds_end==indsbound_aux(2));

            %
            lyesgap_after_aux = lyesgap(inddiff_first_after_aux:end);
            lyesgap_before_aux = lyesgap(1:inddiff_last_before_aux);

            %
            if lyesgap_before_aux(end)

                %
                indbeg_aux = inds_beg(find(~lyesgap_after_aux, 1, 'first'));
                indbeg_aux = indbeg_aux + inddiff_first_after_aux - 1;

            else
                % If there is some overlap with the beginning of the cast

                %            
    %             indbeg_aux = inds_end(find(lyesgap_after_aux, 1, 'last'));
                indbeg_aux = inds_end(find(lyesgap_before_aux, 1, 'last'));
                if isempty(indbeg_aux)
                    indbeg_aux = inds_beg(find(~lyesgap_before_aux, 1, 'first'));
                    % this should be indbeg_aux == 1
                end

            end

        end

    % %     keyboard
        % -----------------------------------------------------------------
        % Edge 2 / right edge

        %
        if trefs(i, 2) > tvec(end)

            indend_aux = inds_end(find(lnogap, 1, 'last'));


        else

            %
            lmatch = tvec==trefs(i, 2);

            if ~any(lmatch)
                indsbound_aux = [find(tvec < trefs(i, 2), 1, 'last'), ...
                                 find(tvec > trefs(i, 2), 1, 'first')];
            else
                indsbound_aux = [find(lmatch), find(lmatch)];
            end

            %
            inddiff_first_after_aux = find(inds_beg==indsbound_aux(1));
            inddiff_last_before_aux = find(inds_end==indsbound_aux(2));

            %
            lyesgap_after_aux = lyesgap(inddiff_first_after_aux:end);
            lyesgap_before_aux = lyesgap(1:inddiff_last_before_aux);

            % If the reference is rightfully in between profiles
            if lyesgap_after_aux(1)

                %
                indend_aux = inds_end(find(~lyesgap_before_aux, 1, 'last'));

            else
                % If there is some overlap with the end of the cast

                %
                indend_aux = inds_beg(find(lyesgap_after_aux, 1, 'first'));
                
                % If the above is empty it means we have to take the
                % last indice because we arrived at the end of tvec
                % with no gap there (or that's what it should be, as
                % long as there are no other bugs)
                if isempty(indend_aux)
                   
                    %
                    indend_aux = inds_end(length(lyesgap_after_aux));
                    
                    if length(tvec)~=(indend_aux + inddiff_first_after_aux - 1)
                        error('Take a look at this!')
                    end
                end
                
                %
                indend_aux = indend_aux + inddiff_first_after_aux - 1;
                
            end
    % %         if i==4
    % %             keyboard
    % %         end
    % % %         keyboard
    % % % 
    % % %         %
    % % %         bla = find(inds_beg(lyesgap & (inds_beg>indsbound_aux(2))), 1, 'first');
    % % % 
    % % %         keyboard
    % % % 
    % % % 
    % % %         %
    % % %         indclosest_edge2_aux = dsearchn(tmid(:), trefs(i, 2));
    % % %     
    % % %         %
    % % %         indbefore_edge2_aux = find(tmid(tvec_diff(lyesgap)) < tmid(indclosest_edge2_aux), 1, 'last');
    % % % 
    % % %         indafter_edge2_aux = find(tmid(tvec_diff(lyesgap)) > tmid(indclosest_edge2_aux), 1, 'first');
    % % %         % what about equal mid-time?????
    % % % 
    % % %         %
    % % %         inddist_before_aux = abs(ind_gap_tdiff(indbefore_edge2_aux) - indclosest_edge2_aux);
    % % %         inddist_after_aux = abs(ind_gap_tdiff(indafter_edge2_aux) - indclosest_edge2_aux);
    % % %         % what about equal ?????
    % % % 
    % % %         %
    % % %         if (inddist_after_aux < inddist_before_aux)
    % % % 
    % % %             indend_aux = inds_beg(indafter_edge2_aux);
    % % % 
    % % %         else
    % % % 
    % % %             indend_aux = inddist_before_aux(indafter_edge2_aux);
    % % % 
    % % %         end
        end
        
    else
        indbeg_aux = [];
        indend_aux = [];
    end
        
    
    % Assign variables to output
    %
    tsplit(i).t = tvec(indbeg_aux:indend_aux);
    tsplit(i).tref = trefs(i, :);
    tsplit(i).indsub = [indbeg_aux, indend_aux];
    
% %     keyboard
    
end


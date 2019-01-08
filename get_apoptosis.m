function [apoptosis_count] = get_apoptosis(tracks)


min_track_length = 30;


IDs = unique(tracks(:,4));
apoptosis_count = [];

for i=1:length(IDs)
    [t] = tracks(tracks(:,4) == IDs(i),:);
    
%     % check to see whether the track is all apoptotic
%     if all(t(:,7) == 4)
%         fprintf('All of track %d is apoptotic. Discarding... \n',IDs(i));
%     elseif any(t(:,7)==4)
%         fprintf('Track %d is apoptotic \n',IDs(i));
%     else
%         disp('Nothing!');
%     end

%     if (mod(i,100) == 0)
%         fprintf('Done %d of %d... \n',i, length(IDs));
%     end
%     
    if (size(t,1) < min_track_length)
        continue;
    end
    
%     % reject if it is within (say 100) pixels of the border
%     if check_border(t, 50)
%         continue;
%     end
    
    % if part of the track is apoptotic (but not all) then select for
    % further fun 
       if any(t(:,7)==4) && ~all(t(:,7)==4)
           
    % fprintf('Track %d is apoptotic \n',IDs(i));
        first_detection = find(t(:,7)==4,1);
        apoptosis_frame = t(first_detection,3);
        ID = t(first_detection,4);
       
        % store the track ID and the first detection frame
        apoptosis_count = cat(1,apoptosis_count, [ID, apoptosis_frame]);
        
       %end table has (ID,FRAME)
       end
        
end

% for j= 1:length(tracks)
%    for i=1:length(apoptosis_count)
%         if tracks(j,4)==apoptosis_count(i,1) && tracks(j,3)>apoptosis_count(i,2)
%             tracks(j,:)=0;
%         end
%    end
% end

  

return


function [b] = check_border(t, dist)

if any(t(:,1) < dist) || any(t(:,2)>1600-dist) || any(t(:,2) < dist) || any(t(:,1) > 1200-dist)
    b=1;
else
    b=0;
end



[P_gfp00] = get_apoptosis(gfp00.tracks);
[P_gfp01] = get_apoptosis(gfp01.tracks);
[P_gfp02] = get_apoptosis(gfp02.tracks);
[P_gfp03] = get_apoptosis(gfp03.tracks);
[P_gfp0] = get_apoptosis(gfp0.tracks);
[P_gfp1] = get_apoptosis(gfp1.tracks);
[P_gfp2] = get_apoptosis(gfp2.tracks);
[P_gfp3] = get_apoptosis(gfp3.tracks);

[P_rfp00] = get_apoptosis(rfp00.tracks);
[P_rfp01] = get_apoptosis(rfp01.tracks);
[P_rfp02] = get_apoptosis(rfp02.tracks);
[P_rfp03] = get_apoptosis(rfp03.tracks);
[P_rfp0] = get_apoptosis(rfp0.tracks);
[P_rfp1] = get_apoptosis(rfp1.tracks);
[P_rfp2] = get_apoptosis(rfp2.tracks);
[P_rfp3] = get_apoptosis(rfp3.tracks);




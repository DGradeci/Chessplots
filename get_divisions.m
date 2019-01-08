function [div_frames] = get_divisions(tracks)

% these are the IDs of the tracks which have been labelled as dividing
% div = tracks.fate_table.dividing;
div = tracks.fates.P_div;
div_frames = [];
lifetimes=[];
divs=[];
cutoff=100;
for i=1:length(div)
    [divID] = div(i);
    frm = max( tracks.tracks(tracks.tracks(:,4)==divID, 3) );
    lifetime=length(tracks.tracks(tracks.tracks(:,4)==divID, 3)); 
    if lifetime>cutoff
    lifetimes=cat(1,lifetimes, lifetime);
    divs= cat(1,divs, divID);
    div_frames = cat(1,div_frames, frm);
    end
end
div_frames(:,2)=divs(:);

%end table has (FRAME, ID)
end
%        
%  count=0;      
%  for k=1:199
%      tic
%      for l=1:471767
%         if rd(k,1)==N_0(l,6) & rd(k,2)==N_0(l,1);
%             count=count+1
%         end
%      end
% end


% [div_gfp0]=get_divisions(gfp0);
% [div_gfp1]=get_divisions(gfp1);
% [div_gfp2]=get_divisions(gfp2);
% [div_gfp3]=get_divisions(gfp3);
% [div_gfp00]=get_divisions(gfp00);
% [div_gfp01]=get_divisions(gfp01);
% [div_gfp02]=get_divisions(gfp02);
% [div_gfp03]=get_divisions(gfp03);
% 
% [div_rfp0]=get_divisions(rfp0);
% [div_rfp1]=get_divisions(rfp1);
% [div_rfp2]=get_divisions(rfp2);
% [div_rfp3]=get_divisions(rfp3);
% [div_rfp00]=get_divisions(rfp00);
% [div_rfp01]=get_divisions(rfp01);
% [div_rfp02]=get_divisions(rfp02);
% [div_rfp03]=get_divisions(rfp03);
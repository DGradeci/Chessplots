function [div_frames] = get_divisions_new(tracks)

% these are the IDs of the tracks which have been labelled as dividing

div = tracks.fate_table.dividing;
div_frames = [];
lifetimes=[];
divs=[];
cutoff=120;
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
%end table has (FRAME,ID)
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

% [div_gfp1] = get_divisions1(gfp00);
% [div_gfp2] = get_divisions1(gfp01);
% [div_gfp3] = get_divisions1(gfp02);
% [div_gfp4] = get_divisions1(gfp03);
% [div_gfp5] = get_divisions1(gfp0);
% [div_gfp6] = get_divisions1(gfp1);
% [div_gfp7] = get_divisions1(gfp2);
% [div_gfp8] = get_divisions1(gfp3);
% 
% [div_rfp1] = get_divisions1(rfp00);
% [div_rfp2] = get_divisions1(rfp01);
% [div_rfp3] = get_divisions1(rfp02);
% [div_rfp4] = get_divisions1(rfp03);
% [div_rfp5] = get_divisions1(rfp0);
% [div_rfp6] = get_divisions1(rfp1);
% [div_rfp7] = get_divisions1(rfp2);
% [div_rfp8] = get_divisions1(rfp3);
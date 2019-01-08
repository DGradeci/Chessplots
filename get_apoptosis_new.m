function [apoptosis] = get_apoptosis_new(tracks)



% these are the IDs of the tracks which have been labelled as dividing
apo = tracks.fate_table.apoptosis;
apo_frames = [];
lifetimes=[];
apops=[];
cutoff=120;
for i=1:length(apo)
    [divID] = apo(i);
    frm = max( tracks.tracks(tracks.tracks(:,4)==divID, 3) );
    lifetime=length(tracks.tracks(tracks.tracks(:,4)==divID, 3)); 
    if lifetime>cutoff
    lifetimes=cat(1,lifetimes, lifetime);
    apops= cat(1,apops, divID);
    apo_frames = cat(1,apo_frames, frm);
    end
end
apo_frames(:,2)=apops(:);
apoptosis(:,1)=apo_frames(:,2);
apoptosis(:,2)=apo_frames(:,1);

%end table has (ID,FRAME)
end


function [P_gfp,P_rfp] = get_apoptosis_sim(N,Papo)
Papo6=[];
test=[];
j=0;
first_detection=0;

Papo6=Papo(Papo(:,2)>8,:);
test=Papo6(Papo6(:,5)>0,:);

for j = 1:length(test)
    first_detection=find(N(:,1)==test(j,1),1);
    if isempty(first_detection)
        test(j,6)=0;
    else
        test(j,6)=N(first_detection,2);
    end
end

P_rfp=test(test(:,6)==1,[1 3]);
P_gfp=test(test(:,6)==0,[1 3]);

%commitment to death happens one frame before because at this frame they
%change type to a dead cell.
P_gfp(:,2)=P_gfp(:,2)-1;
P_rfp(:,2)=P_rfp(:,2)-1;


end
% % 
% [P_gfp1,P_rfp1] = get_apoptosis(N1,Papo1);
% [P_gfp2,P_rfp2] = get_apoptosis(N2,Papo2);
% [P_gfp3,P_rfp3] = get_apoptosis(N3,Papo3);
% [P_gfp4,P_rfp4] = get_apoptosis(N4,Papo4);
% [P_gfp5,P_rfp5] = get_apoptosis(N5,Papo5);
% [P_gfp6,P_rfp6] = get_apoptosis(N6,Papo6);
% [P_gfp7,P_rfp7] = get_apoptosis(N7,Papo7);
% [P_gfp8,P_rfp8] = get_apoptosis(N8,Papo8);

% [P_gfp21,P_rfp21] = get_apoptosis(N2_1,Papo21);
% % [P_gfp22,P_rfp22] = get_apoptosis(N2_2,Papo22);
% [P_gfp23,P_rfp23] = get_apoptosis(N2_3,Papo23);
% [P_gfp24,P_rfp24] = get_apoptosis(N2_4,Papo24);
% 
% [P_gfp31,P_rfp31] = get_apoptosis(N3_1,Papo31);
% [P_gfp32,P_rfp32] = get_apoptosis(N3_2,Papo32);
% [P_gfp33,P_rfp33] = get_apoptosis(N3_3,Papo33);
% 
% [P_gfp41,P_rfp41] = get_apoptosis(N4_1,Papo41);
% [P_gfp42,P_rfp42] = get_apoptosis(N4_2,Papo42);
% [P_gfp43,P_rfp43] = get_apoptosis(N4_3,Papo43);
% 
% [P_gfp51,P_rfp51] = get_apoptosis(N5_1,Papo51);
% [P_gfp52,P_rfp52] = get_apoptosis(N5_2,Papo52);
% [P_gfp53,P_rfp53] = get_apoptosis(N5_3,Papo53);
% 
% 

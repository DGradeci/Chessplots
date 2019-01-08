function [P_gfp,P_rfp] = get_apoptosis_premiter_sim(Papo)

Papo=Papo(Papo(:,5)>0,:);

P_gfp=Papo(ismember(Papo(:,2),[1,3,5,7]),[1 3]);
P_rfp=Papo(ismember(Papo(:,2),[2,4,6,8]),[1 3]);
end
function[div_gfp,div_rfp]=get_divisions_sim(parentlist)

Parentlist_wt=cat(1,parentlist(parentlist(:,4)==1,:),parentlist(parentlist(:,4)==3,:),parentlist(parentlist(:,4)==5,:),parentlist(parentlist(:,4)==7,:));
Parentlist_scrb=cat(1,parentlist(parentlist(:,4)==2,:),parentlist(parentlist(:,4)==4,:),parentlist(parentlist(:,4)==6,:),parentlist(parentlist(:,4)==8,:));

div_gfp=Parentlist_wt(:,[3,1]);
div_rfp=Parentlist_scrb(:,[3,1]);


end
% 
% [div_gfp1,div_rfp1]=get_division1(parentlist1);
% [div_gfp2,div_rfp2]=get_division1(parentlist2);
% [div_gfp3,div_rfp3]=get_division1(parentlist3);
% [div_gfp4,div_rfp4]=get_division1(parentlist4);
% [div_gfp5,div_rfp5]=get_division1(parentlist5);
% [div_gfp6,div_rfp6]=get_division1(parentlist6);
% [div_gfp7,div_rfp7]=get_division1(parentlist7);
% [div_gfp8,div_rfp8]=get_division1(parentlist8);



%  [div_gfp11,div_rfp11]=get_division1(parentlist11);
%  [div_gfp12,div_rfp12]=get_division1(parentlist12);
%  [div_gfp13,div_rfp13]=get_division1(parentlist13);
%  [div_gfp14,div_rfp14]=get_division1(parentlist14);
%  
%  [div_gfp21,div_rfp21]=get_division1(parentlist21);
%  [div_gfp22,div_rfp22]=get_division1(parentlist22);
%  [div_gfp23,div_rfp23]=get_division1(parentlist23);
%  [div_gfp24,div_rfp24]=get_division1(parentlist24);
%  
%  [div_gfp31,div_rfp31]=get_division1(parentlist31);
%  [div_gfp32,div_rfp32]=get_division1(parentlist32);
%  [div_gfp33,div_rfp33]=get_division1(parentlist33);
%  
%  [div_gfp41,div_rfp41]=get_division1(parentlist41);
%  [div_gfp42,div_rfp42]=get_division1(parentlist42);
%  [div_gfp43,div_rfp43]=get_division1(parentlist43);
%  
%  [div_gfp51,div_rfp51]=get_division1(parentlist51);
%  [div_gfp52,div_rfp52]=get_division1(parentlist52);
%  [div_gfp53,div_rfp53]=get_division1(parentlist53);
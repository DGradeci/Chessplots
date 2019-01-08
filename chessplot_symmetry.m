function [symmetry] = chessplot_symmetry( ma )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here


sz =7;
crop_ma = ma(1:sz,1:sz);

% replace Nan with zeros?
crop_ma(isnan(crop_ma)) = 0.;


% difference between upper and lower triangles
lower = tril(crop_ma,0);
upper = triu(crop_ma,0);
symmetry = abs(sum(upper(:)) - sum(lower(:)));% take the absolute value for it

% scale the symmetry?
% symmetry = symmetry / (0.5*sum(crop_ma(:)));

% % define the symmetric part As = (A+A')/2 and the anti-symmetric part Aa = (A-A')/2
% % together this makes A=As+Aa 
% % define ||Aa|| / ||As|| as a measure of symmetry.
% sym = (crop_ma + crop_ma')/2.;
% asym = (crop_ma - crop_ma')/2.;
% symmetry = norm(asym) / norm(sym); 
% 
% figure;
% y=[Conc_div2;Conc_apo2;Conc_net2];
% Labels = {'Division','Apoptosis','Netgrowth'};
% bar(y,0.4);
% set(gca, 'XTick', 1:3, 'XTickLabel', Labels);
% ylim([0 0.013]);
% ylabel('P diff');
% legend('wt 90%','wt 10% (virtual)');
end

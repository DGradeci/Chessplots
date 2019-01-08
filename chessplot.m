function [] = chessplot(property,X,Y,ma,sa,c, varargin)
% CHESSPLOT plots data in the form of a chessplot
%
%
%


% set the color axis here
% r = [-1e-2 1e-2];
    
if ~ischar(property)
    warning('Property should be a string, such as: apoptosis')
end


% % get the precomputed errors
% if nargin>6
%     sm = varargin{1};
%     ca = varargin{2};
%     use_alpha = 1;
% else
%     use_alpha = 0;
% end

if nargin>6
    r = varargin{1};
end


% open the figure
figure;

% set the axes
hchessboard = axes();

% set the colormap
if strcmp(property,'net growth')
    % make a custom colormap
   
    
    % what is the range of values
    if ~exist('r')
        r = [min(ma(:)), max(ma(:))];
    end

    rl = linspace(r(1),r(2),63);
    cmap = zeros(63,3);
       
    crossover = 0.0;
    
    cmap(rl>crossover,1) = 1.; %rl(rl>0) / r(2);
    cmap(rl>crossover,2) = 1.-abs(rl(rl>crossover) / r(2));
    cmap(rl>crossover,3) = 1.-abs(rl(rl>crossover) / r(2));
    
    cmap(rl<=crossover,3) = 1.; 
    cmap(rl<=crossover,1) = 1.-abs(rl(rl<=crossover) / r(1));
    cmap(rl<=crossover,2) = 1.-abs(rl(rl<=crossover) / r(1));

    
    
else
    cmap = colormap;
end



% pcolor and diagonal line
hsurf = pcolor(hchessboard, X-1,Y-1, ma);
colormap(cmap);
hold on
plot(hchessboard, unique(X-1),unique(X-1),'k:','LineWidth',2)
hold off
hcolorbar = colorbar;
if exist('r')
    caxis(r);
end

% smooth the surface?
%hsurf.FaceColor = 'interp';

% set the errors as a function of transparency
% if use_alpha
%     hsurf.FaceAlpha = hsurf.FaceColor;
%     
%     error = 1. - sm;
%     
%     % NOTE THAT WE ARE JUST NORMALISING THIS HERE
%     % WHAT IS THE CORRECT SCALING FOR THE ERROR?
%     
%     error = (error - min(error(:))) / (max(error(:))-min(error(:)));
%     %error(error < 0.) = 0.;
%     %error(error > 1.) = 1.;
%     
%     hsurf.AlphaData = error;
% end

% set the colorbar axis here
% caxis([0 5e-3]);
% caxis
% set the aspect ratio
hchessboard.DataAspectRatioMode = 'manual';
hchessboard.DataAspectRatio = [1.,1.,1.];
hchessboard.PlotBoxAspectRatioMode = 'manual';
hchessboard.PlotBoxAspectRatio = [1.,1.,1.];

% prepare position and size of textboxes
pos = plotboxpos(hchessboard);

[rows,cols]=size(ma);
width = pos(3)/(cols-1);
height = pos(4)/(rows-1);

% create textbox annotations
for i=1:cols-1
      for j=rows-1:-1:1  
          if ~isnan(sa(j,i)) && ~isnan(ma(j,i))  %&& sa(j,i)>0

              % set the text colour based on the colour of the box
              rgb = getrgb(ma(j,i), cmap, hcolorbar.Limits);             
              if rgb(2)> 0.5
                  text_color = 'k';
              else
                  text_color = 'w';
              end

              
              % plot an asterix if we have not data
              if sa(j,i) == 0
                  txt = '*';
                  txtsz=18;
              else
                  txt = num2str(sa(j,i));
                  txtsz=9;
              end
              
              annotation('textbox',[pos(1)+width*(i-1),pos(2)+height*(j-1),width,height], ...
                'string',txt,'LineStyle','none','HorizontalAlignment','center',...
                'VerticalAlignment','middle','Color',text_color,'FontWeight','bold',...
                'FontSize',txtsz);
          else
              %Plot NaN if no/not enough observations
              txt = 'NaN';
              txtsz=18;
          end
      end
      
      % set the tick labels
      xTickString{i} = num2str(i-1);
      
end
      
         




% if we are interpolating, change the position of the tick marks

if strcmp(hsurf.FaceColor, 'interp')
    ticks = linspace(0,cols-2,cols-1);
 else
    ticks = linspace(0.5,cols-1.5,cols-1);
 end

% set the ticks, and axis labels
hchessboard.TickLength = [0.,0.];
hchessboard.XTickMode = 'manual';
hchessboard.XTick = ticks;
hchessboard.XTickLabel = xTickString;
hchessboard.YTickMode = 'manual';
hchessboard.YTick = ticks;
hchessboard.YTickLabel = xTickString;

hchessboard.Color = [0.9 0.9 0.9];

% set the labels
xlabel('Number Scr Kd neighbours')
ylabel('Number wt neighbours')
    
% set the title
cell = {'wt','$scrib^{KD}$'};

title(strcat({'MDCK '},cell{c+1},{' '},property),'Interpreter','latex');

% calculate the symmetry
sym = chessplot_symmetry(ma);
fprintf('Chessboard symmetry for %s is %f \n',cell{c+1}, sym);

% set the colorbar title
hcolorbar.Label.String =  strcat('$\Pr_{',property,'}$');
hcolorbar.Label.Interpreter = 'latex';
hcolorbar.Label.FontSize = 18;

end



function [rgb] = getrgb(v, cmap, lims)
% get the RGB value of a square from the chessboard plot

normalised_value = (v - lims(1)) / (lims(2)-lims(1));
normalised_value = 1+ uint8( max(min(normalised_value,1.),0.)*62. );

rgb = cmap(normalised_value,:);


end


function pos = plotboxpos(h)
%PLOTBOXPOS Returns the position of the plotted axis region
%
% pos = plotboxpos(h)
%
% This function returns the position of the plotted region of an axis,
% which may differ from the actual axis position, depending on the axis
% limits, data aspect ratio, and plot box aspect ratio.  The position is
% returned in the same units as the those used to define the axis itself.
% This function can only be used for a 2D plot.  
%
% Input variables:
%
%   h:      axis handle of a 2D axis (if ommitted, current axis is used).
%
% Output variables:
%
%   pos:    four-element position vector, in same units as h

% Copyright 2010 Kelly Kearney

% Check input

if nargin < 1
    h = gca;
end

if ~ishandle(h) || ~strcmp(get(h,'type'), 'axes')
    error('Input must be an axis handle');
end

% Get position of axis in pixels

currunit = get(h, 'units');
set(h, 'units', 'pixels');
axisPos = get(h, 'Position');
set(h, 'Units', currunit);

% Calculate box position based axis limits and aspect ratios

darismanual  = strcmpi(get(h, 'DataAspectRatioMode'),    'manual');
pbarismanual = strcmpi(get(h, 'PlotBoxAspectRatioMode'), 'manual');

if ~darismanual && ~pbarismanual
    
    pos = axisPos;
    
else

    dx = diff(get(h, 'XLim'));
    dy = diff(get(h, 'YLim'));
    dar = get(h, 'DataAspectRatio');
    pbar = get(h, 'PlotBoxAspectRatio');

    limDarRatio = (dx/dar(1))/(dy/dar(2));
    pbarRatio = pbar(1)/pbar(2);
    axisRatio = axisPos(3)/axisPos(4);

    if darismanual
        if limDarRatio > axisRatio
            pos(1) = axisPos(1);
            pos(3) = axisPos(3);
            pos(4) = axisPos(3)/limDarRatio;
            pos(2) = (axisPos(4) - pos(4))/2 + axisPos(2);
        else
            pos(2) = axisPos(2);
            pos(4) = axisPos(4);
            pos(3) = axisPos(4) * limDarRatio;
            pos(1) = (axisPos(3) - pos(3))/2 + axisPos(1);
        end
    elseif pbarismanual
        if pbarRatio > axisRatio
            pos(1) = axisPos(1);
            pos(3) = axisPos(3);
            pos(4) = axisPos(3)/pbarRatio;
            pos(2) = (axisPos(4) - pos(4))/2 + axisPos(2);
        else
            pos(2) = axisPos(2);
            pos(4) = axisPos(4);
            pos(3) = axisPos(4) * pbarRatio;
            pos(1) = (axisPos(3) - pos(3))/2 + axisPos(1);
        end
    end
end

% Convert plot box position to the units used by the axis

temp = axes('Units', 'Pixels', 'Position', pos, 'Visible', 'off', 'parent', get(h, 'parent'));
set(temp, 'Units', currunit);
pos = get(temp, 'position');
delete(temp);

end
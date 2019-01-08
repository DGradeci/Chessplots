function []=NetGrowth_chessplot(sizeofgrid,c,all_observations,all_div_events,all_apop_events)


%% creating events array in neighbourhood.
% this can be thought of as the numerator part of the chessplots
%it places the number of events in the correct position
%which will then be divided by the number of observations in that position

%create an emtpy grid with dimensions relating to the max number 
%of similar and different neighbours of cells undergoing an event.
div_events_array = zeros(max(all_div_events(:,4)+1), max(all_div_events(:,5))+1); 
apop_events_array = zeros(max(all_apop_events(:,4)+1), max(all_apop_events(:,5))+1); 


%for Divisions
    for i=1:size(all_div_events,1)
        
        %goes through all events and finds the number or wt and scrb
        %neighbors it has, and hence where it belongs on the events grid
        %(position on the chessplot)
        %Note that plus 1 is needed as neighbourhood (0,0) is given by
        %position (1,1) on the chessplot)
        num_wt_neighbours = all_div_events(i,4)+1;
        num_scrb_neighbours = all_div_events(i,5)+1;

        %logs the event as occuring in the correct position relating to its
        %neighbours on the empty grid originally made.
        div_events_array(num_wt_neighbours, num_scrb_neighbours) = div_events_array(num_wt_neighbours, num_scrb_neighbours) + 1;   
    end
    
%for apoptosis    
    for i=1:size(all_apop_events,1)
        
        %goes through all events and finds the number or wt and scrb
        %neighbors it has, and hence where it belongs on the events grid
        %(position on the chessplot)
        %Note that plus 1 is needed as neighbourhood (0,0) is given by
        %position (1,1) on the chessplot)
        num_wt_neighbours = all_apop_events(i,4)+1;
        num_scrb_neighbours = all_apop_events(i,5)+1;

        %logs the event as occuring in the correct position relating to its
        %neighbours on the empty grid originally made.
        apop_events_array(num_wt_neighbours, num_scrb_neighbours) = apop_events_array(num_wt_neighbours, num_scrb_neighbours) + 1;   
    end
    
    
    
%% creating Observations array in neighbourhood.
%this can be thought of as the denomenator part of the chessplots
%it places the number of observation in the correct position
%where observations are all cells at all frames in a given neighbourhood
%independent of whether they underwent an event (divison/apoptosis)or not
observations_array  = zeros(max(all_observations(:,4)+1), max(all_observations(:,5))+1); %% create another empty grid representing neighbourhood of all cells.

      
      for i=1:size(all_observations,1)
          %same as for the events but this time with observations look at
          %the previous section if not sure
          num_wt_neighbour_observations = all_observations(i,4)+1;
          num_scrb_neighbour_observations = all_observations(i,5)+1;
          
          %same as for the events but this time with observations look at
          %the previous section if not sure         
          observations_array(num_wt_neighbour_observations , num_scrb_neighbour_observations) =...
              observations_array(num_wt_neighbour_observations, num_scrb_neighbour_observations) + 1;    
      end  




%% calculating probabilities with Statistics section


%must make observations array same size as events array to calculate
%probabilities, matricies must be the same size to be able to divide
div_observations_array=observations_array(1:size(div_events_array,1),1:size(div_events_array,2));%% make counts array same size as sum array to divide and get percentage
apop_observations_array=observations_array(1:size(apop_events_array,1),1:size(apop_events_array,2));%% make counts array same size as sum array to divide and get percentage
% Filter for neighbourhoods with less than 500 instances as statistically invalid.
for count=1:numel(div_observations_array)
    if div_observations_array(count)<500
         div_observations_array(count)=NaN;
    end
end

for count=1:numel(apop_observations_array)
    if apop_observations_array(count)<500
         apop_observations_array(count)=NaN;
    end
end

%calculate the prob of events by dividing events by observations
div_probability_array = div_events_array./ div_observations_array;
apop_probability_array = apop_events_array./ apop_observations_array;

%standard error array
se_div_array=sqrt(div_probability_array.*(1-div_probability_array)./div_observations_array);
se_apop_array=sqrt(apop_probability_array.*(1-apop_probability_array)./apop_observations_array);

%co-efficent of varience array
cp_div_array=round((se_div_array./div_probability_array)*100);
cp_apop_array=round((se_apop_array./apop_probability_array)*100);




%% formulating visual chessplot

% creates an empty mesh with the size allocated at the start.
[X,Y] = meshgrid(1:sizeofgrid,1:sizeofgrid);



% Adds an extra row and coloumn of Zeros to the events array and
% co-effiecnt of varience array
div_probability_array(:,size(div_probability_array,2)+1)=0;
div_probability_array(size(div_probability_array,1)+1,:)=0;
apop_probability_array(:,size(apop_probability_array,2)+1)=0;
apop_probability_array(size(apop_probability_array,1)+1,:)=0;

% cp_array(:,size(cp_array,2)+1)=0;
% cp_array(size(cp_array,1)+1,:)=0;

r1=size(apop_probability_array,1);
 c1=size(apop_probability_array,2);
 r2=size(div_probability_array,1);
 c2=size(div_probability_array,2);
  
  
%% making the porbability matricies the same size
%by adding empty rows and coloums to the smaller ones, they need to be the
%same size so that you can take them away from each other.
if size(div_probability_array,1)>size(apop_probability_array,1)
    for l=1:(size(div_probability_array,1)-size(apop_probability_array,1))
        apop_probability_array(r1+l,:)=0;
    end
end
if size(apop_probability_array,1)>size(div_probability_array,1)
    for l=1:(size(apop_probability_array,1)-size(div_probability_array,1))
        div_probability_array(r2+l,:)=0;
    end
end

if size(div_probability_array,2)>size(apop_probability_array,2)
    for l=1:(size(div_probability_array,2)-size(apop_probability_array,2))
        apop_probability_array(:,c1+l)=0;
    end
end
if size(apop_probability_array,2)>size(div_probability_array,2)
    for l=1:(size(apop_probability_array,2)-size(div_probability_array,2))
        div_probability_array(:,c2+l)=0;
    end
end

% making the observations matricies the same size
%by adding empty rows and coloums to the smaller ones, they need to be the
%same size so that you can take them away from each other.

if size(div_events_array,1)>size(apop_events_array,1)
    for l=1:(size(div_events_array,1)-size(apop_events_array,1))
        apop_events_array(r1+l,:)=0;
    end
end
    
if size(apop_events_array,1)>size(div_events_array,1)
    for l=1:(size(apop_events_array,1)-size(div_events_array,1))
        div_events_array(r2+l,:)=0;
        div_observations_array(r2+l,:)=0;
    end
end

if size(div_events_array,2)>size(apop_events_array,2)
    for l=1:(size(div_events_array,2)-size(apop_events_array,2))
        apop_events_array(:,c1+l)=0;
    end
end
    
if size(apop_events_array,2)>size(div_events_array,2)
    for l=1:(size(apop_events_array,2)-size(div_events_array,2))
        div_events_array(:,c2+l)=0;
        div_observations_array(:,c2+l)=0;
    end
end


net_growth_array=div_probability_array-apop_probability_array;



%creates square arrays of 0's which will then be logged with the correct
%numbers/probabilities to produce the following chessplots
% probability chess plot, observations chessplot, events chessplot,
% coefficeint of varience chessplot
probability_chessplot=zeros(sizeofgrid);
events_chessplot=zeros(sizeofgrid);
cp_chessplot=zeros(sizeofgrid);
observations_chessplot=zeros(sizeofgrid);


%logs the probabilities calculated into the empty square arrays, and
%includes NaN's for any neighbourhoods that don't exist in the
%probabilities but do in the empty square array
for i=1:sizeofgrid
    for j= 1:sizeofgrid
        if i<size(div_probability_array,1) && j<size(div_probability_array,2)
            probability_chessplot(i,j)=net_growth_array(i,j);
            events_chessplot(i,j)=div_events_array(i,j)+apop_events_array(i,j);
%             cp_chessplot(i,j)=(cp_div_array(i,j)+cp_apop_array(i,j))./2;
            observations_chessplot(i,j)=observations_array(i,j);
        else
            probability_chessplot(i,j)=NaN;
            events_chessplot(i,j)=NaN;
%             cp_chessplot(i,j)=NaN;
            observations_chessplot(i,j)=NaN;
        end
    end
end


% the following is irrelevent because no events is marked with astarix

%if no events are recorded for a given neighbourhood, the probability of
%that neighbourhood is NaN instead of 0.
% for i=1:sizeofgrid
%     for j= 1:sizeofgrid
%         if events_chessplot(i,j)==0
%             probability_chessplot(i,j)=NaN;
%         end 
%     end 
% end 


%% plotting the chessplots

% plots the porbability of an event chessplot
chessplot('net growth', X,Y,probability_chessplot,events_chessplot,c,[-0.1e-2, 0.3e-2]);

% plots the coefficient of varitation
% chessplot('coefficient of variation ', X,Y,cp_chessplot,cp_chessplot,c);

% plots the number of observations chessplot
% chessplot('Number of observations', X,Y,observations_chessplot,observations_chessplot,c);



















end

        
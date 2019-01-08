function []= chessplot_simulation(varargin) 
varargin=varargin{:};
sizeofgrid=9;
ll=varargin;
nl=length(varargin)/3;
gl=2*length(varargin)/3;
rl=length(varargin);



% asks what type of chessplot you want
%division,apoptosis or net growth.
chessplot_type = {'Division','Apoptosis','Net growth','Everything'};
[indx,kk] = listdlg('ListString',chessplot_type,'SelectionMode','single','ListSize',[300,300],'Name','Chessplots v2');

%% If divison chessplot is chosen:
if indx==1 || indx==3
    chessplot_name='Division';
    all_events_gfp=[];
    all_events_rfp=[];
    all_events=[];
    
%divisons 
    for i=1:length(varargin)/3

        %get dividing cell ID's and frames from tracked data
        [T_gfp,T_rfp]=get_divisions_sim(varargin{i+(length(varargin)/3)});
        % select the correct N file corresponding the the position chosen
        N=varargin{i};

        % matches dividing cell ID's and frames to the N matrix
        %(neighbourhood)matrix to calculate the neighbourhood of cells at
        % point of division
        [N_sin_gfp] = N(N(:,2)==0,:);
        [N_sin_rfp] = N(N(:,2)==1,:);
        [ids,~]=ismember(N_sin_gfp(:,[1 6]),T_gfp(:,[2 1]),'rows');
        [idr,~]=ismember(N_sin_rfp(:,[1 6]),T_rfp(:,[2 1]),'rows');

        event_gfp=ids.*N_sin_gfp;
        event_gfp(all(event_gfp==0,2),:)=[];
        event_rfp=idr.*N_sin_rfp;
        event_rfp(all(event_rfp==0,2),:)=[];
        % concatinates all gfp division events
        all_events_gfp=cat(1,all_events_gfp,event_gfp);
        all_events_rfp=cat(1,all_events_rfp,event_rfp);
        clear div_gfp N N_sin_gfp N_sin_rfp
        
        %if net growth is being calculated then we must save the divisins
        %events and label them differently from the apoptoitic events to 
        %subtract the probabilities.
        if indx==3
            all_div_events_gfp=all_events_gfp;
            all_div_events_rfp=all_events_rfp;
        end
    end
end


%% if apoptosis chessplot is chosen:
if indx==2||indx==3 
    
    chessplot_name='Apoptosis';
    all_events_gfp=[];
    all_events_rfp=[];
    all_events=[];
    
    
%GFP Apoptosis 
    for i=1:length(varargin)/3
        
        %Calculates apoptotic cell ID's and frames from tracked data
        [T_gfp,T_rfp]=get_apoptosis_sim(varargin{i},varargin{i+(2*(length(varargin)/3))});
        % select the correct N file corresponding the the position chosen
         N=varargin{i};
         
        [N_sin_gfp] = N(N(:,2)==0,:);
        [N_sin_rfp] = N(N(:,2)==1,:);
        [ids,~]=ismember(N_sin_gfp(:,[1 6]),T_gfp(:,[1 2]),'rows');
        [idr,~]=ismember(N_sin_rfp(:,[1 6]),T_rfp(:,[1 2]),'rows');

        event_gfp=ids.*N_sin_gfp;
        event_gfp(all(event_gfp==0,2),:)=[];
        event_rfp=idr.*N_sin_rfp;
        event_rfp(all(event_rfp==0,2),:)=[];
        % concatinates all gfp division events
        all_events_gfp=cat(1,all_events_gfp,event_gfp);
        all_events_rfp=cat(1,all_events_rfp,event_rfp);
        clear div_gfp N N_sin_gfp N_sin_rfp
        
        %if net growth is being calculated then we must save the divisins
        %events and label them differently from the apoptoitic events to 
        %subtract the probabilities.
        if indx==3
            all_apop_events_gfp=all_events_gfp;
            all_apop_events_rfp=all_events_rfp;
        end
    end
end

   

%% If 'everything' Chessplot is chosen
if indx>3
    chessplot_name='everything';
    msgbox('This function is not avaliable yet');
    return;
end

%% spliting all events and observations into gfp and rfp respectivly 
% to produce seperate chessplots.
all_N= cat(1, varargin{1:nl});

for c=[0,1]
    if c==0
        all_events=all_events_gfp;
        %if net growth is chosen both types of events much be accounted for
        if indx==3
            all_div_events=all_div_events_gfp; 
            all_apop_events=all_apop_events_gfp; 
        end
    elseif c==1
        all_events=all_events_rfp;
        %if net growth is chosen both types of events much be accounted for
        if indx==3
            all_div_events=all_div_events_rfp; 
            all_apop_events=all_apop_events_rfp; 
        end
    end
% split all observations into gfp and rfp respectivly to analyse separatly   
[all_observations] = all_N(all_N(:,2)==c,:);

%% Calculating net growth if chosen --- needs fixing
% if net growth is chosen then the following function is called otherwise 
% if division or apoptosis are chosen then the following lines on this
% script are executed.
if indx==3
    NetGrowth_chessplot(sizeofgrid,c,all_observations,all_div_events,all_apop_events)
    
else

%% creating events array in neighbourhood.
% this can be thought of as the numerator part of the chessplots
%it places the number of events in the correct position
%which will then be divided by the number of observations in that position

%create an emtpy grid with dimensions relating to the max number 
%of similar and different neighbours of cells undergoing an event.
events_array = zeros(max(all_events(:,4)+1), max(all_events(:,5))+1); 

    for i=1:size(all_events,1)
        
        %goes through all events and finds the number or wt and scrb
        %neighbors it has, and hence where it belongs on the events grid
        %(position on the chessplot)
        %Note that plus 1 is needed as neighbourhood (0,0) is given by
        %position (1,1) on the chessplot)
        num_wt_neighbours = all_events(i,4)+1;
        num_scrb_neighbours = all_events(i,5)+1;

        %logs the event as occuring in the correct position relating to its
        %neighbours on the empty grid originally made.
        events_array(num_wt_neighbours, num_scrb_neighbours) = events_array(num_wt_neighbours, num_scrb_neighbours) + 1;   
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
observations_array2=observations_array(1:size(events_array,1),1:size(events_array,2));%% make counts array same size as sum array to divide and get percentage
 
% Filter for neighbourhoods with less than 500 instances as statistically invalid.
for count=1:numel(observations_array2)
    if observations_array2(count)<500
         observations_array2(count)=NaN;
    end
end

%calculate the prob of events by dividing events by observations
probability_array = events_array./ observations_array2;

%standard error array
se_array=sqrt(abs((probability_array.*(1-probability_array))./observations_array2));

%co-efficent of varience array
cp_array=round((se_array./probability_array)*100);




%% formulating visual chessplot

% creates an empty mesh with the size allocated at the start.
[X,Y] = meshgrid(1:sizeofgrid,1:sizeofgrid);



% Adds an extra row and coloumn of Zeros to the events array and
% co-effiecnt of varience array
probability_array(:,size(probability_array,2)+1)=0;
probability_array(size(probability_array,1)+1,:)=0;
cp_array(:,size(cp_array,2)+1)=0;
cp_array(size(cp_array,1)+1,:)=0;



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
        if i<size(probability_array,1) && j<size(probability_array,2)
            probability_chessplot(i,j)=probability_array(i,j);
            events_chessplot(i,j)=events_array(i,j);
            cp_chessplot(i,j)=cp_array(i,j);
            observations_chessplot(i,j)=observations_array2(i,j);
        else
            probability_chessplot(i,j)=NaN;
            events_chessplot(i,j)=NaN;
            cp_chessplot(i,j)=NaN;
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
chessplot(chessplot_name, X,Y,probability_chessplot,events_chessplot,c,[0., 0.3e-2]);

% plots the coefficient of varitation
chessplot('coefficient of variation ', X,Y,cp_chessplot,cp_chessplot,c);

% plots the number of observations chessplot
chessplot('Number of observations', X,Y,observations_chessplot,observations_chessplot,c);


















end
end
end
        

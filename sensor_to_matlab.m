%TYVAUGHN HOLNESS - 4000019648

delete(instrfindall);
clear;

s = serial('COM4');
set(s, 'FlowControl', 'none'); 
set(s, 'BaudRate', 9600);
set(s, 'Parity', 'none');
set(s, 'DataBits', 8); 
set(s, 'StopBit', 1);
fopen(s);

%Create an animated line object to hold the incoming values from ESDX
h = animatedline('MaximumNumPoints',200,'Color','r'); %change 200 if changing graph size
%h2 = animatedline('MaximumNumPoints',200,'Color','b'); %change 200 if changing graph size
x = 0;
y = 0;

%Set up graph
% axis([0 100 1900 2100]);
axis([0 200 60000 70000]);
xlabel('Time');
ylabel('V');

%start the timer and initialize bpm varibales
tic; 
u = 0; d = 0; b=0; bpm=0;

while (1)
     n = fscanf(s);
     y = str2num(n)
     
     if length(y)>1
         y = y(1);
%          y2 = y(2);
     end
     
     
     if isempty(y)
%          y = 2040;
         y = 63000; 
         %y2 = 63000;
     end
%      
%      %BPM CALCULATION
%      if y > 2060 && y < 2090
%         u = 1;          %rising toggle
%      else
%          d = 1;         %falling toggle
%      end     
%      %Counts number of beats via toggles switches 
%      if u == 1 && d == 1 %&& toc < 30.0
%          b = b+1;            %number of beats
%          u=0;d=0;           %resets trhreshold toggles         
%      end
%      %restarts timer and calculated bpm
%      if toc > 10
%              tic;
%              bpm = (b/2)*6
%              b = 0;             %reset beats counter
%      end
%      
%      %OUTPUT TO ESDX
%      out = num2str(bpm);
%      fwrite(s,length(out));
%      for i = 1:length(out)
%          fwrite(s,out(i));
%      end
%      
     %adds new point to the animated line
     addpoints(h,x,y);
     
     %resets the x-axis to create movement
     x=x+1;
     if x>200 %change if changing size of graph
         addpoints(h,200,0);
         addpoints(h,0,0);
%          addpoints(h,0,2040);
         addpoints(h,0,63000);
         x = 0;
     end
         
     %axis([0 100 1900 2100]);
     title(['Heart Rate Monitor','        ','BPM ',num2str(bpm)]); 		%use num2str to convert bpm to char array
     grid on;
     drawnow;     
end



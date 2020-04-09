clear all

if ~isempty(instrfind)
     fclose(instrfind);
      delete(instrfind);
end

s = serial('/dev/tty.usbmodem14201','BaudRate',9600);
fopen(s);

plotTitle = 'MAX86150 PPG';  % plot title
xLabel = 'Elapsed Time (s)';     % x-axis label
yLabel = 'Voltage';      % y-axis label
legend1 = 'PPG Sensor'
yMax  = 50                           %y Maximum Value
yMin  = 45                       %y minimum Value
plotGrid = 'on';                 % 'off' to turn off grid
min = 0;                         % set y-min
max = 100;                        % set y-max
delay = 1*10^-6;                     % make sure sample faster than resolution 

%Define Function Variables
time = 0;
data = 0;
count = 0;

%Set up Plot
plotGraph = plot(time,data,'-r')  % every AnalogRead needs to be on its own Plotgraph
hold on                            %hold on makes sure all of the channels are plotted
title(plotTitle,'FontSize',15);
xlabel(xLabel,'FontSize',15);
ylabel(yLabel,'FontSize',15);
legend(legend1)
axis([yMin yMax min max]);
grid(plotGrid);

tic

while ishandle(plotGraph) %Loop when Plot is Active will run until plot is closed
    pause(0.01);
    dat = fscanf(s); %Data from the arduino
    count = count + 1;    
    time(count) = toc;    
    data(count) = dat(1);         
    %This is the magic code 
    %Using plot will slow down the sampling time.. At times to over 20
    %seconds per sample!
    set(plotGraph,'XData',time,'YData',data);         
    axis([0 time(count) min max]);
    %Update the graph
    pause(delay);
end

disp('Plot Closed and arduino object has been deleted');

fclose(s);
delete(s);

%///////////////////////////////////////////
%go = true;

%while go
    
    %readData = fscanf(s);
    %fprintf(readData);
    
%end 
%///////////////////////////////////////////
%a = arduino()
%dev = device(a,'I2CAddress', '0x5E');
%out = read(dev,1,'uint16');
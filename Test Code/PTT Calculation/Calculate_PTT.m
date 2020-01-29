%PPG is a signal from PhysioNet
load('PPG.mat');

%PPG_Shifted is the same signal artifically shifted 19 elements (time delay
%of ~0.15 seconds)
load('PPG_Shifted.mat')


Fs = 125; %PPG Sampling Rate
t = (0:length(PPG)-1)/Fs; %Time axis

%% Find Peaks in PPG 
MinPeakDistance = 0.3; %Assuming max heart rate of 200 bpm
MinPeakProminence = 0.5*std(PPG); %Min prominence is one half the standard deviation of the signal

%Find pulse peaks in the PPG signal
[~, locs_Peaks] = findpeaks(PPG,...
    'MinPeakDistance', MinPeakDistance,...
    'MinPeakProminence', MinPeakProminence);


%find the valleys in the PPG signal
[~, locs_Mins] = findpeaks(-PPG,...
    'MinPeakDistance', MinPeakDistance,...
    'MinPeakProminence', MinPeakProminence);


%Find pulse peaks in the distal PPG signal
[~, locs_DistalPeaks] = findpeaks(PPG_Shifted,...
    'MinPeakDistance', MinPeakDistance,...
    'MinPeakProminence', MinPeakProminence);

%find the valleys in the PPG signal
[~, locs_DistalMins] = findpeaks(-PPG_Shifted,...
    'MinPeakDistance', MinPeakDistance,...
    'MinPeakProminence', MinPeakProminence);

Beats = struct([]);
for i = 1:length(locs_Peaks)
    ProximalPulse.PeakTime = t(locs_Peaks(i));
    ProximalPulse.PeakMagnitude = PPG(locs_Peaks(i));
    
    %Find the start of each pulse
    startTimeIndx = locs_Mins(find(locs_Mins<locs_Peaks(i), 1, 'last'));
    ProximalPulse.StartTime = t(startTimeIndx);
    ProximalPulse.StartMagnitude = PPG(startTimeIndx);
    
    %Find the corresponding pulse in the distal PPG
    distalPeakIndx = locs_DistalPeaks(find(locs_DistalPeaks>locs_Peaks(i), 1));
    DistalPulse.PeakTime = t(distalPeakIndx);
    DistalPulse.PeakMagnitude = PPG_Shifted(distalPeakIndx);
    
    %find the distal pulse's start time
    DistalStartIndx = locs_DistalMins(find(locs_DistalMins<distalPeakIndx, 1, 'last'));
    DistalPulse.StartTime = t(DistalStartIndx);
    DistalPulse.StartMagnitude = PPG_Shifted(DistalStartIndx);
    

    %Calculate PTT
    PTT = DistalPulse.StartTime - ProximalPulse.StartTime ;

    %Create Beat structure to store this info
    Beat.ProximalPulse = ProximalPulse;
    Beat.DistalPulse = DistalPulse;
    Beat.PTT = PTT;
    
    %add to pulses array
    Beats = cat(1, Beats, Beat);
end


%% Plot Data

hold on

%Plot PPG signals
plot(t, PPG)
plot(t, PPG_Shifted);

%Plot markers
plot(t(locs_Peaks), PPG(locs_Peaks), 'rv');
plot(t(locs_Mins), PPG(locs_Mins), 'rs');
plot(t(locs_DistalPeaks), PPG_Shifted(locs_DistalPeaks), 'gv');
plot(t(locs_DistalMins), PPG_Shifted(locs_DistalMins), 'gs');

legend('Proximal PPG', 'Distal PPG', 'Proximal Peaks', 'Proximal Trough', 'Distal Peaks', 'Distal Troughs');
xlabel('Time (s)')
ylabel('Magnitude')

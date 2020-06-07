classdef BPCalculator < handle
    
    properties
        CurrentSystolic = 120
        CurrentDiastolic = 80
        SystolicCoefficients = [-0.4856 0.0399 0.9651 4.2448]'
        DiastolicCoefficients = [-0.0261 0.4993 0.9444 3.4074]'
        BoxFilter = ones(1,3)/3
        

    end
    
    
    methods
        
        function [Sys, Dias, PTT, HR] = CalculateBP(obj, time, proximalPPG, distalPPG)
            
            
            [PTT, HR] = obj.CalculatePTT(time, proximalPPG, distalPPG);
            
            
            Sys_input = [log(PTT) HR obj.CurrentSystolic 1];
            Dias_input = [log(PTT) HR obj.CurrentDiastolic 1];
            
            Sys = Sys_input*obj.SystolicCoefficients;
            Dias =  Dias_input*obj.DiastolicCoefficients;
            
            %make sure values are valid
            
            if (Dias > Sys) || (Sys>180) || (Dias > 160)
                return
            end
            
            obj.CurrentSystolic = Sys;
            obj.CurrentDiastolic = Dias;
            
            
            
        end

        function [PTT, HR] = CalculatePTT(obj,time, proximalPPG, distalPPG)
            
            %convert datetime vector to float
            time = second(time) + 60 * minute(time) ; 
            time = time(:); %reshape to row vector if necessary
        
            %ensure it is strictly increasing
            indx = [true, (diff(time) > 0)'];
            time = time(indx);
            proximalPPG = proximalPPG(indx);
            distalPPG = distalPPG(indx);
            
            %apply denoising
            proximalPPG = filter( obj.BoxFilter, 1, proximalPPG);
            distalPPG = filter( obj.BoxFilter, 1, distalPPG);

            %remove baseline
            proximalPPG = detrend(proximalPPG);
            distalPPG = detrend(distalPPG);

            MinimumPulseDistance = 0.33; %seconds
            MinPeakProminence = 0;

            %Find pulse peaks in the proximal PPG signal
            [~, locs_ProxPeaks] = findpeaks(proximalPPG, time,...
                'MinPeakDistance', MinimumPulseDistance,...
                'MinPeakProminence', MinPeakProminence);

            %Find pulse peaks in the distal PPG signal
            [~, locs_DistalPeaks] = findpeaks(distalPPG, time,...
                'MinPeakDistance', MinimumPulseDistance,...
                'MinPeakProminence', MinPeakProminence);

            PTTs = nan(length(locs_ProxPeaks),1);
            for i = 1:length(locs_ProxPeaks)

                ProximalPeakTime = locs_ProxPeaks(i);

                %Find the corresponding pulse in the distal PPG
                distalPeakIndx = find(locs_DistalPeaks>ProximalPeakTime, 1, 'first');
                DistalPeakTime = locs_DistalPeaks(distalPeakIndx);

                %Calculate PTT
                ptt = abs(DistalPeakTime - ProximalPeakTime);
                if isempty(ptt)
                    continue
                end
                
                %add to pulses array
                PTTs(i) = ptt;
            end

            PTT = mean(PTTs, 'all', 'omitnan');
            
            %HR Calculation:
            num_beats = (length(locs_ProxPeaks) + length(locs_DistalPeaks))/2;
            time_diff = (time(end)-time(1))/60;
            HR = num_beats/time_diff;
                   
        end
        
        %Parses the PPG values from the arduino data string. 
        function [ProximalPPG, DistalPPG] = ParseDataString(obj,data)
            
            values = regexp(data, "(?<proximal>\d+),(?<distal>\d+)", 'names');
            
            if isempty(values)
                ProximalPPG = [];
                DistalPPG = [];
                return;
            end
            ProximalPPG = str2double(values.proximal);
            DistalPPG = str2double(values.distal);
               
        end
        
    end
end


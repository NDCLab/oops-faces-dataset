%

%%%%%% Label event markers%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% This script labels the emotion, target (same or different), accuracy and validity of stim and
% response markers for the oops faces pilot dataset
%
% This script was created by Emily Martin (and George Buzzell)
%
%% debug code
%eeglab
%EEG = pop_loadbv('C:/Users/eremarti/Desktop/quals/', 'sub-240002_eeg-of_s1_r1_e1.vhdr'); %%%%%%%%%change this
%EEG = eeg_checkset(EEG);
%EEG = pop_resample( EEG, 250);
%EEG = eeg_checkset( EEG );
%for atm=1:length({EEG.event.type})
%    if isnumeric(EEG.event(atm).type)
%        EEG.event(atm).type = num2str(EEG.event(atm).type);
%    end
%end
%eeglab redraw

%%

%all stim and resp markers for the task
all_stimMarkers = {'S  3', 'S  4', 'S  5', 'S  6', 'S  7', 'S  8', 'S 13', 'S 14', 'S 15', 'S 16', 'S 17', 'S 18'};
all_respMarkers = {'S 11', 'S 12', 'S 21', 'S 22'}; 

%subsets of stim/resp markers to be used in switch statements when
%labelling
practice_stimMarkers = {'S  3', 'S  4', 'S  5', 'S  6', 'S  7', 'S  8'};
mainTask_stimMarkers = {'S 13', 'S 14', 'S 15', 'S 16', 'S 17', 'S 18'};

first_stimMarkers = {'S 13', 'S 14'};

sameTar_stimMarkers = {'S 15', 'S 17'};
diffTar_stimMarkers = {'S 16', 'S 18'};

anger_stimMarkers = {'S 17', 'S 18'};
happy_stimMarkers = {'S 15', 'S 16'};

first_RespMarkers = {'S 11', 'S 12'}; 
extra_RespMarkers = {'S 21', 'S 22'}; 

corr_RespMarkers = {'S 11'}; 
error_RespMarkers = {'S 12'}; 

%% Add labels to the event structure 
EEG = pop_editeventfield( EEG, 'indices',  strcat('1:', int2str(length(EEG.event))), ...
    'eventType','NaN', 'target','NaN', 'emotion','NaN', 'responded','NaN', 'accuracy','NaN', ...
    'rt','NaN', 'validRt','NaN', 'extraResponse','NaN', 'validTrial','NaN', ...
    'prevTarget','NaN', 'prevEmotion','NaN', 'prevResponded','NaN', ...
    'prevAccuracy','NaN', 'prevRt','NaN', 'prevValidRt','NaN', ...
    'prevExtraResponse','NaN', 'prevValidTrial','NaN', ...
    'nextTarget','NaN', 'nextEmotion','NaN', 'nextResponded','NaN', 'nextAccuracy','NaN', ...
    'nextRt','NaN', 'nextValidRt','NaN', 'nextExtraResponse','NaN', ...
    'nextValidTrial','NaN');
EEG = eeg_checkset( EEG );

% what each field represents:
% eventType = 'stim' or 'resp'
% target = 's' for same or 'd' for different
% emotion = 'h' for happy or 'a' for anger
% responded = 0 or 1; if participant made a response
% accuracy = 0 or 1; if participant is correct
% rt = in seconds
% validRt = 0 or 1; if rt is more than the cutoff (150ms)
% extraResponse = 0 or 1; if there was a multiple response 
% validTrial = 0 or 1; if no multiple responses, valid RT, and response was made
% prevTarget = 's' or 'd' for previous trial
% prevEmotion = 'h' or 'a' for previous trial
% prevResponded = 0 or 1 for previous trial
% prevAccuracy = 0 or 1 for previous trial
% prevRt = in seconds for previous trial
% prevValidRt = 0 or 1 for previous trial
% prevExtraResponse = 0 or 1 for previous trial
% prevValidTrial = 0 or 1 for previous trial
% nextTarget = 's' or 'd' for next trial
% nextEmotion = 'h' or 'a' for next trial
% nextResponded = 0 or 1 for next trial
% nextAccuracy = 0 or 1 for next trial
% nextRt = in seconds for next trial
% nextValidRt = 0 or 1 for next trial
% nextExtraResponse = 0 or 1 for next trial
% nextValidTrial = 0 or 1 for next trial

%specify cutoff (in s) for how fast a valid rt can be
validRt_cutoff = .150;

%run code on only main task stim markers for now ...
all_stimMarkers_eventNums = find(ismember({EEG.event.type},first_stimMarkers));

%loop through all stim marker event numbers identified in the all_stimMarkers_eventNums vector and label 
for t = all_stimMarkers_eventNums %t = event numbers stored in all_stimMarkers_eventNums
    
    stimEventNum = t;
    
    %label that this is a stimulus event
    EEG.event(t).eventType = 'stim';
    
    %find which TRIAL # this is, useful for context labelling
    stimTrialNum = find(all_stimMarkers_eventNums==t);

    %figure out what the next Trsp EVENT # is, unless this is the last
    %trial in a block. we determine if two stimuli are from seperate blocks
    %by checking the amount of time between events. The ITI is 1-1.3 sec
    %for this task, so each trial should be within <2 sec of each other
    %(we use a cutoff just above this at 3 s).

    if stimTrialNum == 1
        prevStimEventNum = 0;
    elseif (EEG.event(all_stimMarkers_eventNums(stimTrialNum)).latency -  EEG.event(all_stimMarkers_eventNums(stimTrialNum-1)).latency)/EEG.srate < 3 %subtract first stim from previous trial first stim
        prevStimEventNum = all_stimMarkers_eventNums(stimTrialNum-1);
    else
        prevStimEventNum = 0;
    end

    if stimTrialNum == length(all_stimMarkers_eventNums)
        nextStimEventNum = 0;
    elseif (EEG.event(all_stimMarkers_eventNums(stimTrialNum+1)).latency -  EEG.event(all_stimMarkers_eventNums(stimTrialNum)).latency)/EEG.srate < 3 %subtract the next first stim from current first stim
        nextStimEventNum = all_stimMarkers_eventNums(stimTrialNum+1); %make next stim event the next trial second stim
    else
        nextStimEventNum = 0;
    end

    switch EEG.event(t+1).type
        case first_RespMarkers %if there was a response (premature response)
            prematureStim = t;
            prematureResp = t+1;
            EEG.event(t+1).eventType = 'resp';
            responded = 1;
            accuracy = 'NaN';
            rt = 'NaN';
            validRt = 0;
            validTrial = 0;
            target = 'NaN';
            emotion = 'NaN';

            %if there was a response, then look if there was at least one
            %extra response after the first response
            switch EEG.event(t+2).type
                case extra_RespMarkers %if at least one extra response  
                    extraResponse = 1;  
                otherwise %if NO response                
                    extraResponse = 0;             
            end
            for prematureEv = [prematureStim prematureResp]
                if eventNum ~= 0
                    EEG.event(prematureEv).responded = responded;
                    EEG.event(eventNum).extraResponse = extraResponse;
                    EEG.event(eventNum).accuracy = accuracy;
                    EEG.event(eventNum).rt = rt;
                    EEG.event(eventNum).validRt = validRt;
                    EEG.event(eventNum).validTrial = validTrial;
                    EEG.event(eventNum).target = target;
                    EEG.event(eventNum).emotion = emotion;
                end
            end

        otherwise %second face aka normal trial
            secStimEventNum = t+1;
            switch EEG.event(t+2).type
                case first_RespMarkers
                    EEG.event(t+2).eventType = 'resp';  
                    responded = 1;   
                    respEventNum = t+2;
                    
                    %if there was a response, then get rt of response 
                    rt = (EEG.event(t+2).latency - EEG.event(t+1).latency)/EEG.srate;
                    
                    %if there was a response, then determine if rt is valid or not
                    if rt > validRt_cutoff
                        validRt = 1;
                    else 
                        validRt = 0;
                    end  
                            
                    %if there was a response, then get accuracy of response
                    switch EEG.event(t+2).type
                        case corr_RespMarkers %if correct response 
                            accuracy = 1;   
                        case error_RespMarkers %if error response                
                            accuracy = 0;                 
                    end
                    
                    %if there was a response, then look if there was at least one
                    %extra response after the first response
                    switch EEG.event(t+3).type
                        case extra_RespMarkers %if at least one extra response  
                            extraResponse = 1;   
                        otherwise %if NO response                
                            extraResponse = 0;                 
                    end
                    
                    %deterimine if a valid trial or not (single, valid rt response)
                    if responded == 1 && validRt == 1 && extraResponse == 0
                        validTrial = 1;
                    else
                        validTrial = 0;
                    end
                    
                otherwise %if NO response                
                    responded = 0;   
                    extraResponse = 0; 
                    respEventNum = 0; 
                    accuracy = 0;
                    rt = 0;
                    validRt = 0;
                    validTrial = 0;
                end
            end
            for eventNum = [stimEventNum secStimEventNum respEventNum]
                %if trial had no response, RespEventNum will be zero
                if eventNum ~= 0
                    switch EEG.event(t+1).type     
                        case sameTar_stimMarkers
                            EEG.event(eventNum).target = 's';
                        case diffTar_stimMarkers
                            EEG.event(eventNum).target = 'd';
                    end
                    %label stimulus emotion (anger vs happy)
                    switch EEG.event(t+1).type     
                        case anger_stimMarkers
                            EEG.event(eventNum).emotion = 'a';
                        case happy_stimMarkers
                            EEG.event(eventNum).emotion = 'h';
                    end

                    %label whether response for this trial or not
                    EEG.event(eventNum).responded = responded;
                    
                    %label whether there were extra responses for this trial or not
                    EEG.event(eventNum).extraResponse = extraResponse;
                    
                    %label accuracy for this trial
                    EEG.event(eventNum).accuracy = accuracy;
                    
                    %label rt for this trial
                    EEG.event(eventNum).rt = rt;
                    
                    %label whether rt was valid for this trial or not
                    EEG.event(eventNum).validRt = validRt;
                    
                    %label whether valid trial or not (single, valid rt response)
                    EEG.event(eventNum).validTrial = validTrial;

                    if nextStimEventNum ~= 0
                
                        %figure out if a response was made on the NEXT TRIAL. if so, identify event # of
                        %response marker, rt, rt validity, accuracy, presence of extra responses.
                        %
                        switch EEG.event(nextStimEventNum+1).type
                            case first_RespMarkers %if there was a response = premature trial
                                nextResponded = 1;
                                nextValidRt = 0;
                                nextAccuracy = 'NaN';
                                nextValidTrial = 0;
                                nextRt = 'NaN';
                                nextTarget = 'NaN';
                                nextEmotion = 'NaN';
                                switch EEG.event(nextStimEventNum+2).type
                                    case extra_RespMarkers %if at least one extra response  
                                        nextExtraResponse = 1;   
                                    otherwise %if NO response                
                                        nextExtraResponse = 0;                 
                                end
                            otherwise
                                switch EEG.event(nextStimEventNum+2).type      

                                    case first_RespMarkers %if there was a response             
                                        nextResponded = 1;   
                                        nextRespEventNum = nextStimEventNum+2;

                                        %if there was a response, then get rt of response 
                                        nextRt = (EEG.event(nextStimEventNum+2).latency - EEG.event(nextStimEventNum+1).latency)/EEG.srate;

                                        %if there was a response, then determine if rt is valid or not
                                        if nextRt > validRt_cutoff
                                            nextValidRt = 1;
                                        else 
                                            nextValidRt = 0;
                                        end  

                                        %if there was a response, then get accuracy of response
                                        switch EEG.event(nextStimEventNum+2).type
                                            case corr_RespMarkers %if correct response 
                                                nextAccuracy = 1;   
                                            case error_RespMarkers %if error response                
                                                nextAccuracy = 0;                 
                                        end

                                        %if there was a response, then look if there was at least one
                                        %extra response after the first response
                                        switch EEG.event(nextStimEventNum+3).type
                                            case extra_RespMarkers %if at least one extra response  
                                                nextExtraResponse = 1;   
                                            otherwise %if NO response                
                                                nextExtraResponse = 0;                 
                                        end
                            
                                        %deterimine if a valid trial or not (single, valid rt response)
                                        if nextResponded == 1 && nextValidRt == 1 && nextExtraResponse == 0
                                            nextValidTrial = 1;
                                        else
                                            nextValidTrial = 0;
                                        end

                                    otherwise %if NO response                
                                        nextResponded = 0;   
                                        nextExtraResponse = 0; 
                                        nextRespEventNum = 0; 
                                        nextAccuracy = 0;
                                        nextRt = 0;
                                        nextValidRt = 0;
                                        nextValidTrial = 0;

                                end %end switch to determine if response made on next trial
                    
                            %label next stimulus target (same vs different)
                            switch EEG.event(nextStimEventNum+1).type     
                                case sameTar_stimMarkers
                                    EEG.event(eventNum).nextTarget = 's';
                                case diffTar_stimMarkers
                                    EEG.event(eventNum).nextTarget = 'd';
                            end

                            %label next stimulus emotion (anger vs happy)
                            switch EEG.event(nextStimEventNum+1).type     
                                case anger_stimMarkers
                                    EEG.event(eventNum).nextEmotion = 'a';
                                case happy_stimMarkers
                                    EEG.event(eventNum).nextEmotion = 'h';
                            end

                            %label this trial based on whether response on next trial or not
                            EEG.event(eventNum).nextResponded = nextResponded;

                            %label this trial based on whether there were extra responses on next trial or not
                            EEG.event(eventNum).nextExtraResponse = nextExtraResponse;

                            %label this trial based on accuracy of next trial
                            EEG.event(eventNum).nextAccuracy = nextAccuracy;

                            %label this trial based on rt of next trial
                            EEG.event(eventNum).nextRt = nextRt;

                            %label this trial based on whether rt was valid for next trial or not
                            EEG.event(eventNum).nextValidRt = nextValidRt;
                            
                            %label this trial based on whether next trial is a valid trial or not (single, valid rt response)
                            EEG.event(eventNum).nextValidTrial = nextValidTrial;
                        end
        
                    end %end conditional: if nextStimEventNum ~= 0

                    %If this is not the first trial in a block, then also label the
                    %current stim event based on the prior trial
                    if prevStimEventNum ~= 0
                        switch EEG.event(prevStimEventNum+1).type
                            case first_RespMarkers %if there was a response = premature trial
                                    prevResponded = 1;
                                    prevValidRt = 0;
                                    prevAccuracy = 'NaN';
                                    prevValidTrial = 0;
                                    prevRt = 'NaN';
                                    prevTarget = 'NaN';
                                    prevEmotion = 'NaN';
                                    switch EEG.event(prevStimEventNum+2).type
                                        case extra_RespMarkers %if at least one extra response  
                                            prevExtraResponse = 1;   
                                        otherwise %if NO response                
                                            prevExtraResponse = 0;                 
                                    end
                            otherwise
        
                                %figure out if a response was made on the PREVIOUS TRIAL. if so, identify event # of
                                %response marker, rt, rt validity, accuracy, presence of extra responses.
                                switch EEG.event(prevStimEventNum+2).type      

                                    case first_RespMarkers %if there was a response             
                                        prevResponded = 1;   
                                        prevRespEventNum = prevStimEventNum+2;

                                        %if there was a response, then get rt of response 
                                        prevRt = (EEG.event(prevStimEventNum+2).latency - EEG.event(prevStimEventNum+1).latency)/EEG.srate;

                                        %if there was a response, then determine if rt is valid or not
                                        if prevRt > validRt_cutoff
                                            prevValidRt = 1;
                                        else 
                                            prevValidRt = 0;
                                        end  

                                        %if there was a response, then get accuracy of response
                                        switch EEG.event(prevStimEventNum+2).type
                                            case corr_RespMarkers %if correct response 
                                                prevAccuracy = 1;   
                                            case error_RespMarkers %if error response                
                                                prevAccuracy = 0;                 
                                        end

                                        %if there was a response, then look if there was at least one
                                        %extra response after the first response
                                        switch EEG.event(prevStimEventNum+3).type
                                            case extra_RespMarkers %if at least one extra response  
                                                prevExtraResponse = 1;   
                                            otherwise %if NO response                
                                                prevExtraResponse = 0;                 
                                        end
                                            
                                        %deterimine if a valid trial or not (single, valid rt response)
                                        if prevResponded == 1 && prevValidRt == 1 && prevExtraResponse == 0
                                            prevValidTrial = 1;
                                        else
                                            prevValidTrial = 0;
                                        end

                                    otherwise %if NO response                
                                        prevResponded = 0;   
                                        prevExtraResponse = 0; 
                                        prevRespEventNum = 0; 
                                        prevAccuracy = 0;
                                        prevRt = 0;
                                        prevValidRt = 0;
                                        prevValidTrial = 0;

                                end %end switch to determine if response made on previous trial            

                                %label prev stimulus target (same vs different)
                                switch EEG.event(prevStimEventNum+1).type     
                                    case sameTar_stimMarkers
                                        EEG.event(eventNum).prevTarget = 's';
                                        
                                    case diffTar_stimMarkers
                                        EEG.event(eventNum).prevTarget = 'd';
                                end

                                %label prev stimulus emotion (anger vs happy)
                                switch EEG.event(prevStimEventNum+1).type     
                                    case anger_stimMarkers
                                        EEG.event(eventNum).prevEmotion = 'a';
                                    case happy_stimMarkers
                                        EEG.event(eventNum).prevEmotion = 'h';
                                end

                                %label this trial based on whether response on prev trial or not
                                EEG.event(eventNum).prevResponded = prevResponded;

                                %label this trial based on whether there were extra responses on prev trial or not
                                EEG.event(eventNum).prevExtraResponse = prevExtraResponse;

                                %label this trial based on accuracy of prev trial
                                EEG.event(eventNum).prevAccuracy = prevAccuracy;

                                %label this trial based on rt of prev trial
                                EEG.event(eventNum).prevRt = prevRt;

                                %label this trial based on whether rt was valid for prev trial or not
                                EEG.event(eventNum).prevValidRt = prevValidRt;
                
                                %label this trial based on whether prev trial is a valid trial or not (single, valid rt response)
                                EEG.event(eventNum).prevValidTrial = prevValidTrial;
                            end
                        end
                        
                    end %end conditional: if prevStimEventNum ~= 0

                end %end if eventNum ~=0 conditional

            end %end loop through eventNum (stim, stim2, resp) for this trial
        end
    end

end %end loop through all_stimMarkers_eventNums (all trials)
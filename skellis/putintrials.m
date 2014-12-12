%% Organize data into Trials (markers to parameters)
function Data = putintrials(NEV)

    Data.Trial(length(sortNEV(NEV.Data.SerialDigitalIO,'Type','ExpParam',1)))= NEV.Data.SerialDigitalIO(1,1);
    tmp = strncmp({NEV.Data.SerialDigitalIO.Type},'Exp',3);
    trial_count = 1;
    i=1;
    for j=1:length(NEV.Data.SerialDigitalIO)
        if tmp(1,j)== 0
            Data.Trial(trial_count,j-(i-1)) = NEV.Data.SerialDigitalIO(1,j);
        else
            Data.Trial(trial_count,j-(i-1)) = NEV.Data.SerialDigitalIO(1,j);
            trial_count = trial_count+1;
            disp(num2str(trial_count))
            i=j;
        end
    end

end
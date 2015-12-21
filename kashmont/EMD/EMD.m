%This function performs Empirical Mode Decomposition on data, 'h', with a
%sampling frequency of 'Fs'.

%This function is called by EMDanly.m

%Functions called: siftstop.m, Envelopes.m


function [IMFs,residue]=EMD(h,Fs)

IMFs=[];
zero_compare=1;
ext_compare=1;
num_extrema = 0;
num_zeros = 0;
residue = [];

%check that there is enough information to sift in the original data
[stopsift]=siftstop(h,Fs);

res = h;

while stopsift==0
    
    check1=1;
    check2=1;
    check3 = 0;
    check4 = 0;
    S=0;
    x = res;
    x1 = x;
    
    %check1 = 0 and check2 = 0 means data is IMF.
    while check1==1 || check2==1 && S<6
        
        %Call envelopes function to find the max and min points and
        %connected with a cubic spline line to envelope the data
        [maxenv,minenv,avgenv]=Envelopes(x);
        %Calculate difference between mean and data
        possIMF=x(:)-avgenv(:);
        
        clear maxenv minenv avgenv
        
        %%
        %Determine if 'possIMF' meets the criteria of an IMF to stop sifting
        % An IMF is a data set if:
            %(1) The number of zero crossings and extrema in the data set are the same or differ at most by 1.
            %(2) At any point in the data, the mean of the envelope formed by the maxima and minima extrema is zero.
        
        [maxenv,minenv,avgenv]=Envelopes(possIMF);
        %Round avgenv to nearest hundreth
        ravgenv = roundn(avgenv,-2);
        %Find where the average of the maxima and minima envelopes is zero
        avgzeroxing = find(ravgenv==0)';
        %Check1: Does the mean of the envelopes cross zero?  If check1 = 1:
        %the average of the min and max envelopes does not equal zero and
        %the data does not meet the criteria of an IMF.
        check1 = isempty(avgzeroxing);
        
        %Determine number of extrema in the possible IMF (possIMF)
        possIMF_extrema = sign(diff(possIMF));
        extrema = sum(diff(possIMF_extrema)<0 | diff(possIMF_extrema)>0) ;
        num_extrema = horzcat(num_extrema,extrema);
        %Determine number of zero crossings in h
        zeros=sum(find(diff(sign(possIMF)))~=0);
        num_zeros=horzcat(num_zeros,zeros);
        %Find the difference between the number of extrema and the number of zero
        %crossings
        ext_diff = num_extrema(end) - num_zeros(end);
        %Check2: Are the number of zero crossings and extrema the same or differ at
        %most by 1? If check2 = 1: the difference is greater than one and
        %the data does not meet the criteria of an IMF.
        check2 = abs(ext_diff)>1;
        
        if check1 ==1 || check2 == 1 %if data is not an IMF
            %Compare the current and previous number of zero crossings
            zero_compare = num_zeros(end) - num_zeros(end-1);
            %Check3:  Do the number of zero crossings stay the same?
            check3 = abs(zero_compare)==0;
            
            %Compare the current and previous number of extrema
            ext_compare =  num_extrema(end) - num_extrema(end-1);
            %Check4:  Do the numbber of extrema stay the same?
            check4 = abs(ext_compare)==0;
            
            %             x = possIMF;
            %             clear possIMF
        end
        
        if check3 ==1 && check4 ==1
            S = S+1;
        else S = 0;
        end
        
        x = possIMF;
        %If S = 6: Sifting is stopped because the number of zero crossing and number of extrema have
        %not changed and are equal or differ at most by one in 6
        %consecutive sifting attempts.
        %         if S == 8
        %             check1 = 0;
        %             check2 = 0;
        %         end
        
        
    end
    clear ext_diff zeros extrema possIMF_extrema maxenv minenv ravgenv avgenv avgzeroxing
    
    %     if S == 8
    %         stopsift = 1;
    %     else
    IMFs{end+1} = possIMF;
    %calculate the residue by subracting the component from the original
    %data
    res = x1(:) - possIMF(:);
    
    residue = [residue res];
    %Call siftstop function to determine if the data meets the stop
    %criteria
    [stopsift]=siftstop(res,Fs);
    %     end
    
end %stop sifting process for window

IMFs{end+1} = res;

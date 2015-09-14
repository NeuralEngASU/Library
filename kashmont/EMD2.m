function component=EMD2(h,Fs)

component=[];
zero_comp=1;
ext_comp=1;
check1=1;
check2=1;
num_extrema = 0;
num_zeros = 0;

stopsift=siftstop(h,Fs);

%stopsift=0;


while stopsift==0
    
    check1=1;
    check2=0;
    check3=0;
    S=0;
    x1=h;
    
    while S<5 || check1==1 || check2==0 || check3==0 ||  check4 == 1
        
        S=S+1;
        x=h;
        
        %Call envelopes function to find the max and min points and
        %connected with a cubic spline line to envelope the data
        [maxenv,minenv]=Envelopes(x);
        
        %Calculate mean of envelope
        avgenv=(maxenv+minenv)./2;
        
        %Calculate difference between mean and data
        h=x(:)-avgenv(:);
        
        
        
        %%
        %Determine if 'h' meets the criteria of an IMF to stop sifting
        
        [maxenv,minenv]=Envelopes(h);
        avgenv=(maxenv+minenv)./2;
        %Round avgenv to nearest hundreth
        %ravgenv = roundn(avgenv,-2);
        ravgenv = round(avgenv);
        
        %Find where the average of the maxima and minima envelopes is zero
        envzeroxing = find(ravgenv==0)';   
        
        %Determine number of extrema in h
        h_extrema = sign(diff(h));
        extrema = sum(diff(h_extrema)<0 | diff(h_extrema)>0) ;
        num_extrema = horzcat(num_extrema,extrema);
        
        %Determine number of zero crossings in h
        zeros=sum(find(diff(sign(h)))~=0);
        num_zeros=horzcat(num_zeros,zeros);
        
        %Find the difference between the number of extrema and the number of zero
        %crossings
        ext_diff = num_extrema(end) - num_zeros(end);
        
        %Compare the current and previous number of zero crossings
        zero_comp = num_zeros(end) - num_zeros(end-1);
        
        %Compare the current and previous number of extrema
        ext_comp =  num_extrema(end) - num_extrema(end-1);
        
        %Check1: Are the number of zero crossings and extrema the same or differ at
        %most by 1?
        check1 = abs(ext_diff)>1; %stop and imf
        
        %Check2:  Do the number of zero crossings stay the same?
        check2 = abs(zero_comp)==0;
        
        %Check3:  Do the numbber of extrema stay the same?
        check3 = abs(ext_comp)==0;
        
        %Check4: Does the mean of the envelopes cross zero?
        check4 = isempty(envzeroxing);
        
        
    end %means the data meets the criteria of an IMF
    
    component{end+1} = h;
    
    h=x1(:)-h(:); %calculate the residue by subracting the component from the original data
    
    %Call siftstop function to determine if the data meets the stop
    %criteria
    [stopsift]=siftstop(h,Fs);
    
end

component{end+1} = h;


% NFFT = 2^nextpow2(1000); % Next power of 2 from length of y
% Y = fft(blcomps{1},NFFT)/1000;
% f = KT_4.fs/2*linspace(0,1,NFFT/2+1);

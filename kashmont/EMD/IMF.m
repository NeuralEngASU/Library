function su = IMF(n, state, l)

    rand('state',state)
    i = 1;
    while i <= n
        r = 100*rand;
        if (r >= 10) % peak to peak amplitude >= 20
            amp(i) = r;
            i = i + 1;
        end
    end
    
    i = 1;
    while i <= n
        r = 100*rand;
        if (r >= 2*pi) % frequency >= 1;
            freq(i) = r;
            i = i + 1;
        end
    end
    
    shift = rand(n);

    t = 0:0.002:l; % 500 Hz sampling

    su = zeros(1,length(t));

    for i = 1:n
        
       a = amp(i)*sin( (freq(i)*t) + shift(i) );
       su  = su + a;
       figure(1);
       subplot(2,ceil(n/2),i);
       plot(t,a);
       % keyboard
    
    end

    %difference = abs(max(su) - min(su))*0.1;

    %noise = difference*(rand(1,length(t)) - 0.5);
    % mean(noise);

    figure(2);
    plot(t,su, 'k');
    % hold on;
    % plot(x, su+noise, 'r');
    % keyboard
end




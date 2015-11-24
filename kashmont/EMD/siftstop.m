
function [stopsift] = siftstop(x,Fs)

rise_fall = sign(diff(x));

maxpts = (find(diff(rise_fall)<0))+1;

minpts = (find(diff(rise_fall)>0))+1;

s = length(maxpts)+length(minpts);

% stopsift = s<4;

f=2*(round((length(x))/Fs));

extdiff=length(maxpts)-length(minpts);

if extdiff>0
    ppdiff=x(maxpts(1:length(minpts)))-x(minpts);
    avgdiff=mean(ppdiff);
else
    ppdiff=x(maxpts)-x(minpts(1:length(maxpts)));
    avgdiff=mean(ppdiff);
end
    
stopsift = s<f| avgdiff<(2/1000000);
%s<f
end





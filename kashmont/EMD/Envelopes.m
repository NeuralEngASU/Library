function [maxenv,minenv,avgenv]=Envelopes(x)

x   = transpose(x(:));
N=length(x);

rise_fall = sign(diff(x));

%Find local maxima
maxpts = (find(diff(rise_fall)<0))+1;

%Connect local maxima with cubic spline line
maxenv = spline([0 maxpts N],[0 x(maxpts) 0],1:N);
% maxspl = spapi(6,maxpts,x(maxpts));
% maxenv = fnval(maxspl,(1:length(x)));
% maxspl = spaps(maxpts,x(maxpts),1.e-2);
% maxenv = fnval(maxspl,(1:length(x)));

%Find local minima
minpts = (find(diff(rise_fall)>0))+1;

%Connect local minima with cubic spline line
minenv = spline([0 minpts N+1],[0 x(minpts) 0],1:N);
% minspl = spapi(6,minpts,x(minpts));
% minenv = fnval(minspl,(1:length(x)));
% minspl = spaps(minpts,x(minpts),1.e-2);
% minenv = fnval(minspl,(1:length(x)));

%Calculate mean of envelope
avgenv=(maxenv+minenv)./2;

end


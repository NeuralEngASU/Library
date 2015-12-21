%This function forms maxima and minima envelopes of data using a cubic
%spline interpolation. 

%This function is called by EMD.m.

function [maxenv,minenv,avgenv]=Envelopes(x)

x   = transpose(x(:));
N=length(x);

rise_fall = sign(diff(x));

%Find local maxima
maxpts = (find(diff(rise_fall)<0))+1;

%Connect local maxima with cubic spline line
maxenv = spline([0 maxpts N],[0 x(maxpts) 0],1:N);

%Find local minima
minpts = (find(diff(rise_fall)>0))+1;

%Connect local minima with cubic spline line
minenv = spline([0 minpts N+1],[0 x(minpts) 0],1:N);

%Calculate mean of envelope
avgenv=(maxenv+minenv)./2;

end


function [check1,check2]=IMFchk(avgenv, h)

%Determine if h1 meets criteria of IMF; if not, repeat h1 is a pseudo IMF
%and needs further sifting before it is a component.  If it does, h1 is the
%first compenent

%Determine if the mean of the upper and lower envelope is zero at any point in the data set
mean_zero=find(avgenv==0, 1);
%will return 1 if mean_zero matrix is empty and therefore the mean does not
%equal zero, but will return 0 if the matrix is not empty and the mean does
%cross zero.
check1=isempty(mean_zero);

%Determine number of extrema in h
h_extrema = sign(diff(h));
num_extrema= sum(diff(h_extrema)<0 | diff(h_extrema)>0) ;

%Determine number of zero crossings in h
num_zeros=sum(find(diff(sign(h)))~=0);

%Find the difference between the number of extrema and the number of zero
%crossings
ext_diff=num_extrema - num_zeros;
check2=abs(ext_diff)>1;

end
function [up,dn] = envelope(x,y,varargin)
% ENVELOPE estimate upper and lower envelopes of a vector
%    [UP,DN] = ENVELOPE(X,Y) estimates the upper and lower envelopes of the
%    vector y, at the points in x.  Local maxima and minima are found using
%    the derivative, and points between these indices are linearly
%    interpolated.
%
%    [UP,DN] = ENVELOPE(X,Y,METHOD) specifies a different method of
%    interpolation.  For options, see the help for INTERP1.
%
%    Basic idea taken from the envelope function on the Mathworks File
%    Exchange by Lei Wang.

% default method: linear
method='linear';

% user option
if(~isempty(varargin))
    method=varargin{1};
end

% transpose to column vector if needed
transpose_flag=0;
if(size(y,1)<size(y,2))
    transpose_flag=1;
    y=y';
end

% interpolate upper envelope: 
% use derivative (diff) to find convex inflection points - local maxima
up_idx=find(diff(sign(diff([0; y])))<0);

% interpolate lower envelope
% use derivative (diff) to find concave inflection points - local minima
dn_idx=find(diff(sign(diff([0; y])))>0);

% define envelopes: if number of local maxima or minima is less than 0.1%
% of the total number of samples in the signal, just return the original
if(length(up_idx)<0.001*length(x) || length(dn_idx)<0.001*length(x))
    up=y;
    dn=y;
else
    up=interp1(x(up_idx),y(up_idx),x,method,y(up_idx(end)));
    dn=interp1(x(dn_idx),y(dn_idx),x,method,y(dn_idx(end)));
end

% tranpose up/dn if necessary
if(transpose_flag)
    up=up';
    dn=dn';
end
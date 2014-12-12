function m=vec2layout(v,layout)
% M=VEC2LAYOUT(V,LAYOUT) places the elements in V at their proper location
% in matrix M, as determined by LAYOUT.  LAYOUT is a matrix where each
% position contains the channel number (i.e., index into V).

m=nan(size(layout));
[y,idx]=sort(layout(:),'ascend');
m(idx(y>0))=v(y(y>0));
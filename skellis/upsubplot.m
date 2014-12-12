function h=upsubplot(rows,cols,elems,mult)

% height/width subplot matrix
sph=rows*mult;
spw=cols*mult;

% init subplot matrices: column-order first for ease of populating the
% data, then switch to row-order for subplot indices
oldspmat=reshape(1:rows*cols,[cols rows])';
spmat=reshape(1:sph*spw,[spw sph])';

% storing the indices for the new spmat
axlist=zeros(mult*mult,length(elems));
for k=1:length(elems)
    [r,c]=find(oldspmat==elems(k));
    spidx_row=(r-1)*mult+1;
    spidx_row=spidx_row:spidx_row+mult-1;
    spidx_col=(c-1)*mult+1;
    spidx_col=spidx_col:spidx_col+mult-1;
    axlist(:,k)=reshape(spmat(spidx_row,spidx_col)',[mult*mult 1]);
end

% open up the subplot
h=subplot(sph,spw,sort(axlist(:)));
function [idx,val]=findclosest(vec,tgt,thrsh)

[err,idx]=min(abs(vec-tgt));
val=vec(idx);
if(err>thrsh)
    idx=[];
    val=[];
end
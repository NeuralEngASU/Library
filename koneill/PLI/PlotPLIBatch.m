pathName = 'E:\data\PLI\downsampleddata\';

grids = defgrids;

maxPLIs = zeros(1, length(grids));

for ii = 1:length(grids)
    
    load(sprintf('%s\\g%dmpli_UNR.mat',pathName,ii))
    
    maxPLIs(ii) = max(squeeze(mean(p,1)));
    
end % END FOR grids
% Extension of the CircStat package
function [circMean, circVar, vMParams, vMScale, RMSE ,vMCorr, circStd, circSkew, circKurt] = CircStats(tmpDeltaPhi)

binEdge = [-pi:pi/100:pi];

[counts,centers] = hist(tmpDeltaPhi,binEdge);

% Mean
% [circMean(:,:,1), circMean(:,:,2), circMean(:,:,3)] = circ_mean(repmat(centers, 1, size(tmpDeltaPhi,3)), counts, 1);
[circMean(:,:,1), circMean(:,:,2), circMean(:,:,3)] = circ_mean(tmpDeltaPhi);

% Median
circMed(:,:,1) = circ_median(tmpDeltaPhi);

% Varience
circVar = circ_var(tmpDeltaPhi);

% std
[circStd(:,:,1), circStd(:,:,2)] = circ_std(tmpDeltaPhi);

% Skewness
[circSkew(:,:,1), circSkew(:,:,2)] = circ_skewness(tmpDeltaPhi);

% Kurtosis
[circKurt(:,:,1), circKurt(:,:,2)] = circ_kurtosis(tmpDeltaPhi);

% vMParams
sizePair = size(tmpDeltaPhi,1);
for ii = 1:sizePair
    [vMParams(:,ii,1), vMParams(:,ii,2)] = circ_vmpar(centers, counts(:,ii));
    [vm, ~] = circ_vmpdf(centers, vMParams(:,ii,1), vMParams(:,ii,2));
    
    coeffs = fminunc(@(c) PLISqrErr(c,centers, counts(ii), centers, vm),[1;1]);
    
    vMScale(:,ii,1) = coeffs(2);
    
    RMSE(:,ii,1) = sqrt(mean((counts(ii) - coeffs(2)*vm).^2));
    RMSE(:,ii,2) = sqrt(circ_mean((counts(ii) - coeffs(2)*vm).^2));

    [vMCorr(:,ii,1), vMCorr(:,ii,2)] = circ_corrcc(counts(ii),  coeffs(2)*vm);

end % END FOR

vMR2(:,:,1) = vMCorr(:,:,1).^2;

end % END FUNCTION

% EOF
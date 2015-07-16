%%
% foreach number of classes
%   select word pair
%   foreach 'word pair'
%       for twenty times per pair
%           randomly select data
%               stratified cross validation
%               SVM training
%               SVM testing

% Define looping params
numClass = 11;
numRNGTry = 30;
kFoldSize = 10;

% Define data params
dataParams.timeBounds = [0.9, 1.6] * 10; % 800 msec
dataParams.useP = 1;
dataParams.useR = 1;
dataParams.classes = [1,2];
dataParams.trainRatio = 0.5;
dataParams.fileName = 'Delta_ProcessedTrialData_PLI_winSize0.1.mat';
dataParams.pathName = 'E:\data\PLI\delta\PLIOutput';
dataParams.couplingPairsIdx = [];

% Find the channel pairs to analyze
load(fullfile(dataParams.pathName, dataParams.fileName), 'chanPairNums');

desiredChans = [1:32];
pairChans = [1:32];

idx = false(size(chanPairNums,1),1);

for kk = desiredChans
    refChan = kk;
    chansPlot = [refChan, pairChans];
    % Find Idx
    desiredChanPairs = nchoosek(sort(unique(chansPlot),'ascend'),2);
    
    % Find idicies
    for jj = 1:size(desiredChanPairs,1)
        idx = idx | ((chanPairNums(:,1) == refChan) & (chanPairNums(:,2) == desiredChanPairs(jj,2)));
    end
end

dataParams.couplingPairsIdx = idx;

genCVParams = 1;

if ~genCVParams
%     cvParams = cvParams;
end %END IF

% Define results
labelPredict = cell(numClass - 1,1);
accOut = cell(numClass - 1,1);
for ii = 1:numClass-1
    labelPredict{ii} = zeros(nchoosek(numClass,ii+1), numRNGTry, 1);
    accOut{ii} = zeros(nchoosek(numClass, ii+1), numRNGTry);
end % END FOR

%%

for numClassPair = 2:numClass
    wpList = nchoosek(1:numClass,numClassPair); % Generate the class pairings
    for wp = 1:size(wpList,1)
        dataParams.classes = wpList(wp,:);
        for tryRNG = 1:numRNGTry
            rng(tryRNG);
            
            % Gather Data
            [trainData, trainLabels, testData, testLabels] = PLISVMSelectData(dataParams, tryRNG);
            
            % Partition Cross Validation
%             cv = cvpartition(trainLabels,'KFold',kFoldSize);
            
            % Generate cross-validation params if true
%             if genCVParams
%                 
%             end % END IF genCVParams
            
            % Train SVM
            t = templateSVM('Standardize', 1, 'KernelFunction', 'gaussian', 'BoxConstraint',1, 'KernelScale', 1);
            Mdl = fitcecoc(trainData', trainLabels, 'Learners', t, 'Coding', 'onevsone');
            
            % Test SVM
            % SVM Predict (MATLAB)
            predicted = predict(Mdl, testData');
            
            % Record Results
            labelPredict{numClassPair-1}(wp, tryRNG, 1:size(predicted,1)) = predicted;
            accOut{numClassPair-1}(wp,tryRNG) = sum(predicted == testLabels)/numel(predicted);
            
            clc;
            fprintf('Num Class: %d/%d\n', numClassPair,numClass)
            fprintf('Word Pair: %d/%d\n', wp, size(wpList,1));
            fprintf('RNG Cycle: %d/%d\n', tryRNG, numRNGTry);
        end % END FOR try different RNGs
        
        save('E:\data\PLI\delta\PLIOutput\PLI_AllChan_Delta.mat', 'accOut', 'labelPredict', '-v7.3')
    end % END FOR each word pair
end % END FOR each number of class pairs

%% plot
figure;
hold on;

for kk = 1:size(accOut,1)
    x = [kk+1-0.5, kk+1+0.5];
    y = [1/(kk+1), 1/(kk+1)];
    plot(x,y,'k')
end

for kk = 1:size(accOut,1)
    x = ones(size(accOut{kk},1),1)*(kk+1);
    scatter(x,mean(accOut{kk},2));
    
end % END FOR

xlim([1,12])
ylim([0,1])

% EOF


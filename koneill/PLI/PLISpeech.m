%%
nchoosek(11,2) + nchoosek(11,3) + nchoosek(11,4) + nchoosek(11,5) + ...
    nchoosek(11,6) + nchoosek(11,7) + nchoosek(11,8) + nchoosek(11,9) + ...
    nchoosek(11,10) + nchoosek(11,11)
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
numRNGTry = 20;
kFoldSize = 10;

% Define data params
dataParams.timeBounds = [0.8, 1.6] * 10;
dataParams.useP = 1;
dataParams.useR = 1;
dataParams.classes = [1,2];
daraParams.trainRatio = 0.5;

genCVParams = 1;

if ~genCVParams
%     cvParams = cvParams;
end %END IF

% Define results
labelPredict = cell(numClass - 1,1);
accOut = cell(numClass - 1,1);
for ii = 1:numChan-1
    labelPredict{ii} = zeros(nchoosek(numClass,ii+1), numRNGTry, 1);
    accOut{ii} = zeros(nchoosek(numClass, ii+1), numRNGTry);
end % END FOR

accOut = 

%%

for numClassPair = 2:numClass
    wpList = nchoosek(1:numClass,numClassPair); % Generate the class pairings
    for wp = 1:size(wpList,1)
        dataParams.classes = wpList(wp,:);
        for tryRNG = 1:numRNGTry
            rng(tryRNG);
            
            % Gather Data
            [trainData, trainLabels] = SelectTrain(dataParams);
            [testData, testLabels] = SelectTest(dataParams);
            
            % Partition Cross Validation
            cv = cvpartition(classCount,'KFold',kFoldSize);
            
            % Generate cross-validation params if true
            if genCVParams
                
            end % END IF genCVParams
            
            % Train SVM
            t = templateSVM('Standardize', 0, 'KernelFunction', 'gaussian', 'BoxConstraint',1, 'KernelScale', 1);
            Mdl = fitcecoc(trainData', trainLabels, 'Learners', t, 'Coding', 'onevsone');
            
            % Test SVM
            % SVM Predict (MATLAB)
            predicted = predict(Mdl, testData');
            
            % Record Results
            labelPredict{numClassPair-1}(wp, tryRNG, 1:size(predicted,1)) = predicted;
            accOut{numClassPair-1}(wp,tryRNG) = sum(predicted == testLabels)/numel(predicted);
        end % END FOR try different RNGs
    end % END FOR each word pair
end % END FOR each number of class pairs
% Double Cross validation

load('oils.mat')
samples = Data.samples;

[validation, test] = splitData(samples);

% 10 fold validation
SplitsNumber = 10;
indices = crossvalind('Kfold',validation,SplitsNumber);

for foldIndex = 1:SplitsNumber
    test = (indices == foldIndex);
    train =~ test;
    trainSampleNumbers = validation(train,:);
    trainSamples = getAllSamplesIndexes(samples, trainSampleNumbers);
    
    testSampleNumbers = validation(test,:);
    testSamples = getAllSamplesIndexes(samples, testSampleNumbers);
    % evaluate the performance of classifier
end

% evaluate on idependent test set

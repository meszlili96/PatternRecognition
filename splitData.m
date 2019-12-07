function [validationSet, testSet] = splitData(samples, testSplit)
%Splits data into validation and idependent tests set
%   samples - array of samples with duplicated samples
%   testSplit - the percentage of the samples to leave in the tests set
%   from 0 to 1, the default is 0.25
%
%   output:
%   validationSet - array of unique ids of samples to use as validation set
%   testSet - array of unique ids of samples to use as test set

if nargin<2
  testSplit = 0.25;
end

uniqueSamples = unique(samples);
shuffledUniqueSamples = uniqueSamples(randperm(length(uniqueSamples)));
divisionBoundary = round(length(uniqueSamples)*(1-testSplit));
validationSamples = shuffledUniqueSamples(1:divisionBoundary);
testSamples = shuffledUniqueSamples(divisionBoundary+1:end);

validationSet = validationSamples;
testSet = testSamples;
end


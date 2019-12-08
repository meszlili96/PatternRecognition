function [validationSet, testSet] = splitData(samples, countries, testSplit)
%Splits data into validation and idependent tests set
%   samples - array of samples with duplicated samples
%   testSplit - the percentage of the samples to leave in the tests set
%   from 0 to 1, the default is 0.25
%
%   output:
%   validationSet - array of unique ids of samples to use as validation set
%   testSet - array of unique ids of samples to use as test set

if nargin<3
  testSplit = 0.25;
end

% we split data by country to have the same percentage of samples from
% different countrues in both test and training data sets
validationSamples = {};
testSamples = {};
countriesCodes = unique(countries);

for i=1:length(countriesCodes)
    code = countriesCodes(i);
    neededCountry = (countries == code);
    countrySammples = samples(neededCountry,:);
    uniqueSamples = unique(countrySammples);
    shuffledUniqueSamples = uniqueSamples(randperm(length(uniqueSamples)));
    divisionBoundary = round(length(uniqueSamples)*(1-testSplit));
    validationSamples{i} = shuffledUniqueSamples(1:divisionBoundary);
    testSamples{i} = shuffledUniqueSamples(divisionBoundary+1:end);
end

validationSet = validationSamples;
testSet = testSamples;
end


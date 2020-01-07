function [folds] = kFoldSplit(samples, countries, folds_number)
%Splits data into k validation and idependent tests set
%   samples - array of samples with duplicated samples
%   testSplit - the percentage of the samples to leave in the tests set
%   from 0 to 1, the default is 0.25
%
%   output:
%   validationSet - array of unique ids of samples to use as validation set
%   testSet - array of unique ids of samples to use as test set

if nargin<3
  folds_number = 4;
end

% we split data by country to have the same percentage of samples from
% different countrues in both test and training data sets
folds = {};
for k=1:folds_number
    folds{k}.train = [];
    folds{k}.test = [];
end
%validationSamples = [];
%testSamples = [];
countriesCodes = unique(countries);

for i=1:length(countriesCodes)
    code = countriesCodes(i);
    neededCountry = (countries == code);
    countrySammples = samples(neededCountry,:);
    uniqueSamples = unique(countrySammples);
    shuffledUniqueSamples = uniqueSamples(randperm(length(uniqueSamples)));
    fraction = 1/folds_number;
    
    for k=1:folds_number
        first_ind = round(length(uniqueSamples)*(k-1)*fraction)+1;
        second_ind = round(length(uniqueSamples)*k*fraction);
        testSamples = shuffledUniqueSamples(first_ind:second_ind);
        validationSamples = shuffledUniqueSamples;
        validationSamples(first_ind:second_ind) = [];
        folds{k}.train = [folds{k}.train; validationSamples];
        folds{k}.test = [folds{k}.test; testSamples];
    end
end

end


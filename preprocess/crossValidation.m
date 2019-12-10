% Double Cross validation

load('oils.mat')
samples = Data.samples;
countries = Data.countries;
values = Data.values;

[validation, test] = splitData(samples, countries);

%find minimum by country
N = length(validation);
min = length(validation{1});
for i = 2:N
    if length(validation{i}) < min
        min = length(validation{i});
    end
end

% to have at least one item by country
SplitsNumber = min;
indices = {};
% by country
for i = 1:N
    current_country_val = validation{i};
    indices{i} = crossvalind('Kfold',current_country_val,SplitsNumber);
end

% cross ffol validation is in this loop
for foldIndex = 1:SplitsNumber
    % by country
    trainSampleNumbers = [];
    testSampleNumbers = [];
    for i = 1:N
        test1 = (indices{i} == foldIndex);
        train1 =~ test1;
        testSampleNumbers1 = validation{i}(test1,:);
        testSampleNumbers = [testSampleNumbers; testSampleNumbers1];
        trainSampleNumbers1 = validation{i}(train1,:);
        trainSampleNumbers = [trainSampleNumbers; trainSampleNumbers1];
    end

    trainSamples = getAllSamplesIndexes(samples, trainSampleNumbers);
    trainValues = values(trainSamples,:);
    trainCountries = countries(trainSamples);
    
    testSamples = getAllSamplesIndexes(samples, testSampleNumbers);
    testValues = values(testSamples);
    testCountries = countries(testSamples);
    % evaluate the performance of classifier
    
end

% evaluate on idependent test set

% Double Cross validation

load('oils.mat')
samples = Data.samples;
countries = Data.countries;
values = Data.values;

[validation, test] = splitData(samples, countries);

% leave one out cross-validation
splitsNumber = length(validation);

for foldIndex = 1:splitsNumber
    % by country
    fprintf('Fold %d from %d \n', foldIndex, splitsNumber);
    testSampleNumbers = validation(foldIndex);
    trainSampleNumbers = validation;
    trainSampleNumbers(foldIndex) = [];

    trainSamples = getAllSamplesIndexes(samples, trainSampleNumbers);
    trainValues = values(trainSamples,:);
    trainCountries = countries(trainSamples);
    fprintf('Train samples\n');
    fprintf('%.4f ', trainSamples);
    fprintf('\n');
    
    testSamples = getAllSamplesIndexes(samples, testSampleNumbers);
    testValues = values(testSamples,:);
    testCountries = countries(testSamples);
    fprintf('Test samples\n');
    fprintf('%.4f ', testSamples);
    fprintf('\n');
    
    % pre-processing (mean-centering) 
    [trainValues, trainMeans] = mncn2(trainValues);
    % apply means calculated for training set to the tets set
    testValues = mncn2(testValues, trainMeans);
    
    % evaluate the performance of classifier for different number of latent
    % variables
    
    
end

% calculate RMSE for different number of latent variables and select an
% optimal number of latent variables

prompt = 'Please enter the number of latent variables';
lvNumber = input(prompt);

% evaluate on idependent test set
testSamples = getAllSamplesIndexes(samples, test);
testValues = values(testSamples,:);
testCountries = countries(testSamples);

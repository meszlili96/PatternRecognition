% Double Cross validation

load('../data/oils.mat')
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

%prompt = 'Please enter the number of latent variables';
%lvNumber = input(prompt);

vars = [210    89   135   171   128   103   248   425];
%vars = [310   462   136   296   457   533   205   516];

% evaluate on idependent test set
trainSamples = getAllSamplesIndexes(samples, validation);
trainValues1 = values(trainSamples,:);
trainCountries = countries(trainSamples);

% evaluate on idependent test set
testSamples = getAllSamplesIndexes(samples, test);
testValues1 = values(testSamples,:);
testCountries = countries(testSamples);

trainValues = trainValues1(:,vars);
testValues = testValues1(:,vars);

% pre-processing (mean-centering) 
[trainValues, trainMeans] = mncn2(trainValues);
% apply means calculated for training set to the tets set
testValues = mncn2(testValues, trainMeans);

[ldaclass,err,p,logp,coeff]=classify(testValues,trainValues,trainCountries,'linear');
disp(['LDA error rate is ' int2str(100*sum(ldaclass~=testCountries)/size(testCountries,1))])

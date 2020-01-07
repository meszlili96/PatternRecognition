% load GA results
clear
load('../data/oils.mat')
samples = Data.samples;
countries = Data.countries;
values = Data.values;
wavelengths = Data.wavelength;

top_features = load('top_features.txt', '-ASCII');
top_features = top_features(1:8);

folds = kFoldSplit(samples, countries);
folds_num = length(folds);

error_rates = zeros(1, folds_num);
for k=1:folds_num
    validation = folds{k}.train;
    test = folds{k}.test;
    
    % training data set
    trainSamples = getAllSamplesIndexes(samples, validation);
    trainValues = values(trainSamples,:);
    trainCountries = countries(trainSamples);
    
    % idependent test set
    testSamples = getAllSamplesIndexes(samples, test);
    testValues = values(testSamples,:);
    testCountries = countries(testSamples);
    
    trainValues1 = trainValues(:,top_features);
    testValues1 = testValues(:,top_features);
    
    % pre-processing (mean-centering)
    [trainValues1, trainMeans] = mncn2(trainValues1);
    % apply means calculated for training set to the tets set
    testValues1 = mncn2(testValues1, trainMeans);
    
    [ldaclass,err,p,logp,coeff]=classify(testValues1,trainValues1,trainCountries,'linear');
    error_rates(k) = 100*sum(ldaclass~=testCountries)/size(testCountries,1);
end

fprintf('4-fold CV mean error rate with features selected by GA %.4f ', mean(error_rates));
fprintf('\n');

top_wavelengths = wavelengths(top_features);

fprintf('Top wavelengths \n');
disp(top_wavelengths)


% load GA results
clear
load('../data/oils.mat')
samples = Data.samples;
countries = Data.countries;
values = Data.values;
wavelengths = Data.wavelength;

features_sets = load('features.txt', '-ASCII');

folds = kFoldSplit(samples, countries);
folds_num = length(folds);

% zero loo cv error solutions number
D = 24;

solution_mean_errors = zeros(1, D);
for d=1:D
    features = features_sets(d,:);
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
        
        trainValues1 = trainValues(:,features);
        testValues1 = testValues(:,features);
        
        % pre-processing (mean-centering)
        [trainValues1, trainMeans] = mncn2(trainValues1);
        % apply means calculated for training set to the tets set
        testValues1 = mncn2(testValues1, trainMeans);
        
        [ldaclass,err,p,logp,coeff]=classify(testValues1,trainValues1,trainCountries,'linear');
        error_rates(k) = 100*sum(ldaclass~=testCountries)/size(testCountries,1);
    end
    
    solution_mean_errors(d) = mean(error_rates);
    fprintf('GA solution %.4f: 4-fold CV average error %.4f ', d, mean(error_rates));
    fprintf('\n');
end

fprintf('Mean top GA solutions 4-fold CV average error %.4f ', mean(solution_mean_errors));
fprintf('\n');


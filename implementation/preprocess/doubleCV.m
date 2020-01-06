function [average_error] = doubleCV(samples,countries,values)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
[validation, test] = splitData(samples, countries);

% leave one out cross-validation
splitsNumber = length(validation);
errors_rates = zeros(1, splitsNumber);
for foldIndex = 1:splitsNumber
    % by country
    %fprintf('Fold %d from %d \n', foldIndex, splitsNumber);
    testSampleNumbers = validation(foldIndex);
    trainSampleNumbers = validation;
    trainSampleNumbers(foldIndex) = [];

    trainSamples = getAllSamplesIndexes(samples, trainSampleNumbers);
    trainValues = values(trainSamples,:);
    trainCountries = countries(trainSamples);
    %fprintf('Train samples\n');
    %fprintf('%.4f ', trainSamples);
    %fprintf('\n');
    
    testSamples = getAllSamplesIndexes(samples, testSampleNumbers);
    testValues = values(testSamples,:);
    testCountries = countries(testSamples);
    %fprintf('Test samples\n');
    %fprintf('%.4f ', testSamples);
    %fprintf('\n');
    
    % pre-processing (mean-centering) 
    [trainValues, trainMeans] = mncn2(trainValues);
    % apply means calculated for training set to the tets set
    testValues = mncn2(testValues, trainMeans);
    
    % evaluate the performance of classifier for different number of latent
    % variables
    [ldaclass,err,p,logp,coeff]=classify(testValues,trainValues,trainCountries,'linear');
    errors_rates(foldIndex) = 100*sum(ldaclass~=testCountries)/size(testCountries,1);
    %disp(['LDA error rate is ' int2str(error_rate)]);
end

average_error = mean(errors_rates);

end


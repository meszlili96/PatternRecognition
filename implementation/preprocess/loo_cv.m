function [average_error] = loo_cv(validation,samples,countries,values)
%   LOO with duplicates handling
%   used as GA fitness function

splitsNumber = length(validation);
errors_rates = zeros(1, splitsNumber);
for foldIndex = 1:splitsNumber
    testSampleNumbers = validation(foldIndex);
    trainSampleNumbers = validation;
    trainSampleNumbers(foldIndex) = [];

    trainSamples = getAllSamplesIndexes(samples, trainSampleNumbers);
    trainValues = values(trainSamples,:);
    trainCountries = countries(trainSamples);
    
    testSamples = getAllSamplesIndexes(samples, testSampleNumbers);
    testValues = values(testSamples,:);
    testCountries = countries(testSamples);
    
    % pre-processing (mean-centering) 
    [trainValues, trainMeans] = mncn2(trainValues);
    % apply means calculated for training set to the tets set
    testValues = mncn2(testValues, trainMeans);
    
    [ldaclass,err,p,logp,coeff]=classify(testValues,trainValues,trainCountries,'linear');
    errors_rates(foldIndex) = 100*sum(ldaclass~=testCountries)/size(testCountries,1);
end

average_error = mean(errors_rates);

end


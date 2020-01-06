
clear
load('../data/oils.mat')
samples = Data.samples;
countries = Data.countries;
values = Data.values;

lvs = 8; N=10; T=100; CR=0.8; MR=0.05; 
[sFeat,curve]=ga(samples,countries,values, lvs, N, T, CR, MR);

% Plot convergence curve
figure(); plot(1:T,curve); xlabel('Number of Iterations');
ylabel('Fitness Value'); title('GA'); grid on;

vars = sFeat;

[validation, test] = splitData(samples, countries);
% evaluate on idependent test set
trainSamples = getAllSamplesIndexes(samples, validation);
trainValues = values(trainSamples,:);
trainCountries = countries(trainSamples);

% evaluate on idependent test set
testSamples = getAllSamplesIndexes(samples, test);
testValues = values(testSamples,:);
testCountries = countries(testSamples);

trainValues = trainValues(:,vars);
testValues = testValues(:,vars);

% pre-processing (mean-centering) 
[trainValues, trainMeans] = mncn2(trainValues);
% apply means calculated for training set to the tets set
testValues = mncn2(testValues, trainMeans);

[ldaclass,err,p,logp,coeff]=classify(testValues,trainValues,trainCountries,'linear');
disp(['LDA error rate is ' int2str(100*sum(ldaclass~=testCountries)/size(testCountries,1))])


% perfoms specified number of GA runs, prints statistics and saves the
% results
clear;
addpath '../preprocess';
load('../data/oils.mat')
samples = Data.samples;
countries = Data.countries;
values = Data.values;

[validation, test] = splitData(samples, countries);
% training data set
trainSamples = getAllSamplesIndexes(samples, validation);
trainValues = values(trainSamples,:);
trainCountries = countries(trainSamples);

% idependent test set
testSamples = getAllSamplesIndexes(samples, test);
testValues = values(testSamples,:);
testCountries = countries(testSamples);

% get baseline for random selection of subset of 8th features
Cycles_num = 1000;
lvs = 8;
D=size(values,2);
random_error_rates = zeros(1, Cycles_num);
for i=1:Cycles_num
    selected_features = [];
    while length(selected_features) < lvs
        feature_num = randi([1 D],1,1);
        if ~ismember(feature_num,selected_features)
            selected_features = [selected_features, feature_num];
        end
    end
    
    trainValues1 = trainValues(:,selected_features);
    testValues1 = testValues(:,selected_features);
    
    % pre-processing (mean-centering) 
    [trainValues1, trainMeans] = mncn2(trainValues1);
    % apply means calculated for training set to the tets set
    testValues1 = mncn2(testValues1, trainMeans);
    [ldaclass,err,p,logp,coeff]=classify(testValues1,trainValues1,trainCountries,'linear');
    random_error_rates(i) = 100*sum(ldaclass~=testCountries)/size(testCountries,1);
end

fprintf('Average random features selection error rate %.4f ', mean(random_error_rates));
fprintf('\n');

% Set up the GA parameters
Cycles_num = 100;
N=50; T=50; CR=0.8; MR=0.05;
ga_error_rates = zeros(1, Cycles_num);
features_sets = zeros(Cycles_num,lvs);
for i=1:Cycles_num
    [vars,curve]=ga(validation, samples, values, countries, lvs, N, T, CR, MR, 0);
    
    % Plot convergence curve
    %figure(); plot(1:length(curve),curve); xlabel('Number of Iterations');
    %ylabel('Fitness Value'); title('GA'); grid on;
    
    trainValues1 = trainValues(:,vars);
    testValues1 = testValues(:,vars);
    
    % pre-processing (mean-centering)
    [trainValues1, trainMeans] = mncn2(trainValues1);
    % apply means calculated for training set to the tets set
    testValues1 = mncn2(testValues1, trainMeans);
    
    [ldaclass,err,p,logp,coeff]=classify(testValues1,trainValues1,trainCountries,'linear');
    ga_error_rates(i) = 100*sum(ldaclass~=testCountries)/size(testCountries,1);
    features_sets(i,:) = vars;
    fprintf('Cycle %.4f double CV error rate %.4f ', i, ga_error_rates(i));
    fprintf('\n ');
    % save after each run not to lose the results if process is terminated
    save('features.txt','features_sets','-ascii')
    save('ga_error_rates.txt','ga_error_rates','-ascii')
end

% print the results and save on the disk
fprintf('Average GA features selection error rate %.4f ', mean(ga_error_rates));
fprintf('\n');

% sort error rates and obtained solutions (features_sets) by error rate in ascending order
[ga_error_rates,idx]=sort(ga_error_rates);
features_sets = features_sets(idx,:);

zero_error_rate = sum(ga_error_rates==0);
fprintf('zero error rate num %.4f ', zero_error_rate);
save('features.txt','features_sets','-ascii')
save('ga_error_rates.txt','ga_error_rates','-ascii')

occurences = zeros(1, D);
for i=1:D
    occurences(i) = sum(features_sets(:)==i);
end

save('features_occurences.txt','occurences','-ascii');

[top_features_oc, idx] = sort(occurences,'descend'); top_features = idx(1:10);
save('top_features.txt','top_features','-ascii');


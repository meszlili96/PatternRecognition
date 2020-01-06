
clear
load('../data/oils.mat')
samples = Data.samples;
countries = Data.countries;
values = Data.values;

[validation, test] = splitData(samples, countries);
% evaluate on idependent test set
trainSamples = getAllSamplesIndexes(samples, validation);
trainValues = values(trainSamples,:);
trainCountries = countries(trainSamples);

% evaluate on idependent test set
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

Cycles_num = 5;
ga_error_rates = zeros(1, Cycles_num);
features_sets = zeros(Cycles_num,lvs);
for i=1:Cycles_num
    N=50; T=100; CR=0.8; MR=0.05;
    [sFeat,curve]=ga(validation, samples,values,countries, lvs, N, T, CR, MR, 0);
    
    % Plot convergence curve
    %figure(); plot(1:length(curve),curve); xlabel('Number of Iterations');
    %ylabel('Fitness Value'); title('GA'); grid on;
    
    vars = sFeat;
    
    trainValues1 = trainValues(:,vars);
    testValues1 = testValues(:,vars);
    
    % pre-processing (mean-centering)
    [trainValues1, trainMeans] = mncn2(trainValues1);
    % apply means calculated for training set to the tets set
    testValues1 = mncn2(testValues1, trainMeans);
    
    [ldaclass,err,p,logp,coeff]=classify(testValues1,trainValues1,trainCountries,'linear');
    ga_error_rates(i) = 100*sum(ldaclass~=testCountries)/size(testCountries,1);
    features_sets(i,:) = vars;
    fprintf('Iteration %.4f error rate %.4f ', i, ga_error_rates(i));
    fprintf('\n ');
end

fprintf('Average GA features selection error rate %.4f ', mean(ga_error_rates));
fprintf('\n');

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
save('top_features.txt','occurences','-ascii');

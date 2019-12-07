function [MissClass_2cv,Q2_2cv,RP,T_final]=OPLSDA_2cv2(X,y,LV,testsetindices,sc)
% [MissClass_2cv,Q2_2cv,RP,T_final]=OPLSDA_2cv2(X,y,LV,testsetindices,sc)
%
% Simple implementation of a Double crossvalidation of OPLSDA model.
% In the inner loop the optimal number of latent variables is determined
% (based on the minimum in the plot of the error versus the number of
% latent variables).
% In the outer loop the performance of the OPLS prediction is determined
% using the defined test sets based on a set of indices of the data that the 
% routine should use as test sets. 
% The inner CV is a LOO.
%
% input:
%   X  = data
%   y  = class labels (0 or 1)
%   LV = max number of LV's
%   testsetindices = matrix defining samples in X to leave out in each 
%           submodel (outer cross-validation).
%           E.g. in case of a data set with 6 samples the matrix
%           [1 2;3 4;5 6] defines three submodels in which samples 1,2 , 
%           3,4 and 5,6 are left out in turns and used as test sets 
%           (the remaining samples constitute the set on which the
%           inner cross-validation is applied). A Venetian blinds procedure
%           for n samples could be implemented using e.g. 
%           first-sample-number : step-size : n. E.g. 1:3:n; 2:3:n; etc.
%           The user is responsible for stratified sampling and coverage of 
%           the data.
%   sc = scaling: sc = 1: autoscaling
%               sc = 2: paretoscaling (not working)
%               sc = 0: no scaling (mean centering is executed by default)
% output:
%   MissClass_2cv:    number of miss classified samples at optimal # LV
%                     based on the testset samples
%   Q2_2cv:           Maximum Q^2 value at optimal # LV
%   RP:               average of number of latent variables determined
%                     in inner loop as optima.
%                     (Note: modified : was originally the RankProduct 
%                     calculated from all innerloop models.)
%   T_final:          OPLS crossvalidated T-scores
%   (GJP: DQ2 removed)
% Note, this version centers y, which is necessary when the class sizes are
% unequal.
%
% Remember: in this routine the optimal number of latent variables is 
% determined by the minimum of the PRESS obtained in the inner loop.
% Inner loop is Leave-one-Out CV.
%
% Johan Westerhuis
% UvA-BDA
% 27/2/2007
% Modified by GJ Postma RU, IMM, Dec 2012.

%% Initialization
[I,J]   = size(X);
[It]    = size(testsetindices,1);
RP      = ones(1,J);
T_final = zeros(I,LV+1);
tested = []; % GJP
Y_test = []; % GJP
MinLVs = []; % GJP
output = 1;
%% Outer loop starts, 
% Samples are split up in test and rest
% Scaling parameters are calculated on rest and used to correct rest and
% test
% Inner loop is used to define optimal number of LV's
% A model is build on rest using optimal LVt.
% based on test predictions, missclassifications and Q2 are calculated
% Rank product (RP) is calculated from all models from rest

for m = 1:It
    % GJP
    eval(['disp(''Evaluation ' num2str(m) ' of ' num2str(It) ''')'])
    
    % Select test, rest
    rest = 1:I;
    v = find(~isnan(testsetindices(m,:)));
    test = testsetindices(m,v);
    tested = [tested, test]; % GJP
    rest(test) = [];
    
    % Scale rest
    mX_rest = mean(X(rest,:));sX_rest = std(X(rest,:));
    my_rest = mean(y(rest));
    if sc == 1
        % GJP X_rest_s = scale(X(rest,:),mX_rest,sX_rest); % This is auto scaling
        X_rest_s = (X(rest,:) - (ones(size(X(rest,:),1),1)*mX_rest))./(ones(size(X(rest,:),1),1)*sX_rest);
    elseif sc == 2
        X_rest_s = scale(X(rest,:),mX_rest,sqrt(sX_rest)); % This is Pareto scaling
    else
        % GJP X_rest_s = scale(X(rest,:),mX_rest,ones(1,J)); % This is no scaling
        X_rest_s = X(rest,:) - (ones(size(X(rest,:),1),1)*mX_rest);
    end
    y_rest = y(rest) - my_rest;

    % Scale test
    if sc == 1
        % GJP X_test_s = scale(X(test,:),mX_rest,sX_rest); % This is auto scaling
        X_test_s = (X(test,:) - (ones(size(X(test,:),1),1)*mX_rest))./(ones(size(X(test,:),1),1)*sX_rest);
    elseif sc == 2
        X_test_s = scale(X(test,:),mX_rest,sqrt(sX_rest)); % This is Pareto scaling
    else
        % GJP X_test_s = scale(X(test,:),mX_rest,ones(1,J)); % This is no scaling
        X_test_s = X(test,:) - (ones(size(X(test,:),1),1)*mX_rest);
    end
        
    %% Inner loop starts
    % Here LOO crossval is done in inner loop
    % rest is used in inner loop and split up in train and val
    % scaling parameters are calculated on train and used to correct train
    % and val
    % a model is built on train and val is predicted
    % optimal # LV's is obtained

    Y_val = zeros(I,LV);
    [Itr] = length(rest);
    for itr = 1:Itr
        train = rest;
        val = rest(itr);
        train(itr) = [];
       
        % Scale train
        mX_train = mean(X(train,:));sX_train = std(X(train,:));
        my_train = mean(y(train));
        if sc == 1
            % GJP X_train_s = scale(X(train,:),mX_train,sX_train); % This is auto scaling
            X_train_s = (X(train,:) - (ones(size(X(train,:),1),1)*mX_train))./(ones(size(X(train,:),1),1)*sX_train);
        elseif sc == 2
            X_train_s = scale(X(train,:),mX_train,sqrt(sX_train)); % This is Pareto scaling
        else    
            % GJP X_train_s = scale(X(train,:),mX_train,ones(1,J)); % This is no scaling
            X_train_s = X(train,:) - (ones(size(X(train,:),1),1)*mX_train);
        end
        y_train_m = y(train) - my_train;         % Here y_train is centered
        
        % Scale validation set
        if sc == 1
            % GJP X_val_s = scale(X(val,:),mX_train,sX_train); % This is auto scaling
            X_val_s = (X(val,:) - (ones(size(X(val,:),1),1)*mX_train))./(ones(size(X(val,:),1),1)*sX_train);
        elseif sc == 2
            X_val_s = scale(X(val,:),mX_train,sqrt(sX_train)); % This is Pareto scaling
        else    
            % GJP X_val_s = scale(X(val,:),mX_train,ones(1,J)); % This is no scaling
            X_val_s = X(val,:) - (ones(size(X(val,:),1),1)*mX_train);
        end
        
        % build PLS model
        [w,t,p,q,T_o,P_o,W_o] = OPLS(X_train_s,y_train_m,LV);
        % GJP: loop over all LVs is missing. Added.
        for ilv = 1:LV
            % Predict val. GJP: LV -> ilv
            [t_val,Tnew_o,y_val_hat] = OPLSpred(X_val_s,P_o,W_o,w,q,ilv);
            % Collect val predictions
            % GJP Y_val(val,:) = y_val_hat + my_train;
            Y_val(val,ilv) = y_val_hat + my_train;
        end
    end % End of inner loop
    
    % Calculation of PRESS
    PRESS = sum((Y_val(rest,:) - y(rest)*ones(1,LV)).^2);
    [PRESS_min,MinLV] = min(PRESS);
    
    % Calculate best model using AUROC curve
    %for lv = 1:LV
    %    [tp, fp] = roc(Y_val(rest,LV)-0.5,y(rest)-0.5);
    %    A(lv) = auroc(tp, fp);
    %end
    %[AUC_min,MinLV] = min(A);
   
    %Make model of rest
    [w,t,p,q,T_o,P_o,W_o] = OPLS(X_rest_s,y_rest,MinLV);
    % Predict test
    [t_test,Tnew_o,y_test_hat_c] = OPLSpred(X_test_s,P_o,W_o,w,q,MinLV);
    % Collect Test scores
    T_final(test,1) = t_test;
    T_final(test,2:MinLV+1) = Tnew_o;
    % Correction of y centering 
    y_test_hat = y_test_hat_c(:,end) + my_rest;
    % Collect test predictions
    % GJP: not completely safe if not all data are used for testing. Then
    % Y_test in this way contains 'holes' (zeros) at positions of data not
    % tested.
    % GJP: Y_test(test,:) = y_test_hat;
    Y_test = [Y_test; y_test_hat];
    % Calculate rank product
   %[Ib,Jb] = sort(-1*abs(b(MinLV,:)));
    %RP = RP.*Jb;
    % GJP: as RP is not used, calculate average of MinLV
    MinLVs = [MinLVs, MinLV];
end % End of outer loop

%% Summarizing
%% Calculate Q2
% GJP: y -> y(tested) to make procedure safe in case not all data are
% tested in outer loop
PRESS_All = sum((Y_test - y(tested)).^2);
% GJP my = y(tested) - ones(I,1)*mean(y(tested));
my = y(tested) - ones(length(tested),1)*mean(y(tested));
SS_All = my'*my;
Q2_2cv = 1 - (PRESS_All/SS_All);
% DQ2 = dq2(Y_test,y(tested)); % GJP: removed. what does it do???? Reuse RP
% for calculating mean of MinLV
RP = mean(MinLVs);
%% Calculate Missclassified
% GJP: y -> y(tested) to make procedure safe in case not all data are
% tested in outer loop
E_All = Y_test - 0.5; % Threshold 0.5
% GJP: Class_All = zeros(I,1);
Class_All = zeros(length(tested),1);
[E_Alli] = find(E_All > 0);
Class_All(E_Alli) = 1;
% GJP: MissClass_2cv = sum(abs(Class_All - y));
MissClass_2cv = sum(abs(Class_All - y(tested)));
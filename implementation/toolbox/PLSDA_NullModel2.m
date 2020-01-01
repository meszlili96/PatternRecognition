function [pvar,p_model]=PLSDA_NullModel2(X,y,nlv,tol,nvalout,nvalin,preprocessing,output);

%   [pvar,p_model]=PLSDA_NullModel2(X,y,nlv,tol,nvalout,nvalin,preprocessing,output);
%      (seems based on
%      [p,errorTOT_Perm,errorTOT_Real,Bperm]=PLSDA_NullModel(X,y,nlv,nvalout,nvalin,preprocessing,output);)
%
%   Performs permutation test for testing significance of classification.
%
% Output:
%   pvar         significance of b-values: 
%                probability that absolute value of b-values for each 
%                variable of the permuted data is larger than the absolute
%                b-value for that variable of a real model.
%   p_model      Probability of randomized models performing equal or better 
%                than original.
%   (previous version: 
%       errorTOT_Perm   total # of errors from permuted models
%       errorTOT_Real   total # of errors from real models (only use relative to nvalout or errorTOT_Perm)
%       Bperm           Discriminant functions from permuted models: null distribution of b for each variable
%       )
%
% Input:
%   X           X data
%   y           y data --> original class membership
%   nlv         number of latent variables to use
%   tol         obsolete: for future version: p-value for significance test
%               which still has to be added. Insert any value.
%   nvalout     number of permutations
%   nvalin      number of resamplings of the cross-validation performed by
%               PLSDA_CrossVal2.m
%   preprocessing       Which preprocessing? : 0=nothing, 1=mean centering, 2= autoscaling
%   output      graphical output switch (1=yes, other=no)
%
% The progress of the function is shown by messages that are printed
% on screen after completion of every 10% of nvalout.
%   
%   Based on PLSDA_Crossval version which now produces error fraction
%   instead of total number of error observed during the CV.
%   GJP: modified to use PLSDA_Crossval2 instead of PLSDA_Crossval
%   (functionality still the same). Test nvalin times for each class 1 
%   randomly selected sample. 
%   Also modified: applies C1_PLSprins.m as pls.m .
%   The permutation test is not completely correct if the number of samples
%   in both classes is different. The current version assumes equal class
%   sizes as it tests in the embedded Crossvalidation function each time 
%   1 sample of each class.

nsmps=length(y);	
yun=unique(y);
%% Real Model
[errorTOT_Real]=PLSDA_CrossVal2(X,y,nlv,nvalin,preprocessing,0);
errorTOT_Real=errorTOT_Real(nlv);

if preprocessing==1
    % GJP [breal] = pls(mncn(X),mncn(y),nlv,0);
    [breal] = C1_PLSprins(mncn(X),mncn(y),nlv);
elseif preprocessing==2;
    % GJP [breal] = pls(auto(X),mncn(y),nlv,0);
    [breal] = C1_PLSprins(autosc(X),mncn(y),nlv);
elseif preprocessing==0;
    % GJP [breal] = pls(X,y,nlv,0);
    [breal] = C1_PLSprins(X,y,nlv);
end
% in C1_PLSprins b0 also present, so remove; and layout of matrix is turned:
breal = breal(2:end,:);
breal = breal';

%%  Permutations

for ival=1:nvalout
    if round(ival/(0.1*nvalout))-ival/(0.1*nvalout)==0
        eval(['disp(''Evaluation ' num2str(ival) ' of ' num2str(nvalout) ''')'])
    end
    yperm=y(randperm(nsmps));
    [Temp]=PLSDA_CrossVal2(X,yperm,nlv,nvalin,preprocessing,0);
    errorTOT_Perm(ival)=Temp(nlv);
    
    if preprocessing==1
        % GJP C1_PLSprins instead of pls, so remove 4th input argument:
        [bperm] = C1_PLSprins(mncn(X),mncn(yperm),nlv);
    elseif preprocessing==2;
        [bperm] = C1_PLSprins(auto(X),mncn(yperm),nlv);
    elseif preprocessing==0;
        [bperm] = C1_PLSprins(X,yperm,nlv);
    end
    % GJP add because of C1_PLS prins
    bperm = bperm(2:end,:);
    bperm = bperm';
    Bperm(ival,:)=bperm(nlv,:)';
end

errorTOT_Real
p_model=sum(errorTOT_Perm<errorTOT_Real)/nvalout;
for inow=1:length(breal)
    if breal(inow)<0;
        pvar(inow,1)=sum(Bperm(:,inow)<breal(inow))./length(Bperm(:,inow));
    elseif breal(inow)>0;
        pvar(inow,1)=sum(Bperm(:,inow)>breal(inow))./length(Bperm(:,inow));
    elseif breal(inow)==0;
        pvar(inow,1)=NaN;
    end
end

if output==1
    figure
    hist(errorTOT_Perm)
    % GJP unknown: vline(errorTOT_Real,'r')
    hold on
    yl = ylim;
    xlim([0, 1]);
    plot([errorTOT_Real, errorTOT_Real], [0, yl(2)], 'r-');
    xlabel('fraction of errors')
    ylabel('# of models')
    suptitle('Error Histogram')
    eval(['title(''p= ' num2str(p_model) ' permutations as good as original. Red: error fraction real model'')'])
end

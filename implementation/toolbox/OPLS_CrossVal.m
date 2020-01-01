function [RMSEPy]=OPLSDA_Crossval(X,y,nlv,preprocessing,output);
%   Cross validation to determine rank of PLS-DA models
%   in/out:
%   [error_fraction]=OPLSDA_Crossval(X,y,nlv,nvals,preprocessing,output);
%
%   output:
%   errorTOT            Fraction of erroneously classified samples per # of LVs
%   input:
%   X                   data (no preprocessing)
%   y                   class (no preprocessing)
%   nlv                 maximum # of LVs for analysis
%   nvals               # of validations
%   preprocessing       Which preprocessing? : 0=nothing, 1=mean centering, 2= autoscaling
%   output              output ? 0 if no


for ival=1:size(X,1);
    if output~=0
        if round(ival/(nvals/10))-ival/(nvals/10)==0
            eval(['disp(''Evaluation ' num2str(ival) ' of ' num2str(nvals) ''')'])
        end
    end
   %% generate training and test set
    ioutA=ival;
    
    Xtest=X(ioutA,:);
    ytest=y(ioutA);
    Xtrain=X;Xtrain(ioutA,:)=[];
    ytrain=y;ytrain(ioutA,:)=[];
    %%  Preprocess training set
    if preprocessing==1
        [Xtrainmc,xtrainmean]=mncn(Xtrain);
        [ytrainmc,ytrainmean]=mncn(ytrain);
    elseif preprocessing==2;
        [Xtrainmc,xtrainmean,xtrainstd]=nanauto(Xtrain);
        [ytrainmc,ytrainmean]=mncn(ytrain);
    elseif preprocessing==3;
        [Xtrainmc,xtrainmean,xtrainstd]=pareto(Xtrain);
        [ytrainmc,ytrainmean]=mncn(ytrain);
    elseif preprocessing==0;
        Xtrainmc=Xtrain;xtrainmean=zeros(1,size(Xtrain,2));
        Ytrainmc=ytrain;ytrainmean=0;
    end
    %%  Preprocess test set
    if preprocessing==1
            Xtestsc=scale(Xtest,xtrainmean);
    elseif preprocessing==2;
        Xtestsc=scale(Xtest,xtrainmean,xtrainstd);
    elseif preprocessing==3;
        Xtestsc=scale(Xtest,xtrainmean,xtrainstd);
    elseif preprocessing==0;
        Xtestsc=Xtest;
    end
        
    %%  Fit model for different lvs
    for ilv=1:nlv;
        [w,t,p,q,T_o,P_o,W_o] = OPLS(Xtrainmc,ytrainmc,ilv);
        [tnew,Tnew_o,ypredm] = OPLSpred(Xtestsc,P_o,W_o,w,q,ilv);
        ypred(ilv,ival)=ypredm+ytrainmean;
        dpred(ilv,ival)=(y(ival)-ypred(ilv,ival)).^2;
    end
end
RMSEPy=sqrt(sum(dpred,2));


if output~=0
    figure;hold on
    plot(RMSEPy,'ro-')
    xlabel('# of LVs')
    ylabel('error fraction')
    title('Cross Validation')
end



function [w,t,p,q,T_o,P_o,W_o] = OPLS(X,y,LV);

% Johan Westerhuis
% Biosystems Data Analysis
% University of AMsterdam

% LV orthogonal components are calculated after which 1 predictive
% component is calculated

% JAW: 20 juli 2007

[I,J] = size(X);
[I,K] = size(y);

T_o = [];
P_o = [];
W_o = [];

E = X;
w = (inv(y'*y)*y'*E)';  
w = w / sqrt(w'*w);

for lv = 1:LV;    
    t = inv(w'*w)*E*w;
    % c = (inv(t'*t)*t'*y)'; 
    % u = (inv*c'*c)*y*c;
    % These are two strange lines. For single y c is a scaler (so why
    % transposing it). Furthermore, c and u are not used anymore
    p = (inv(t'*t)*t'*E)';

    w_o = p - (inv(w'*w)*w'*p)*w;
    w_o = w_o / sqrt(w_o'*w_o);
    t_o = inv(w_o'*w_o)*E*w_o;
    p_o = (inv(t_o'*t_o)*t_o'*E)';

    E = E - t_o*p_o';

    T_o = [T_o t_o];
    P_o = [P_o p_o];
    W_o = [W_o w_o];
end

w = (inv(y'*y)*y'*E)';
w = w / sqrt(w'*w);
t = inv(w'*w)*E*w;
p = (inv(t'*t)*t'*E)';
q = (inv(t'*t)*t'*y)';

function [tnew,Tnew_o,yhat] = OPLSpred(Xnew,P_o,W_o,w,q,LV);

% Johan Westerhuis
% Biosystems Data Analysis
% University of AMsterdam

% JAW: 20 juli 2007

[I,J] = size(Xnew);

Enew = Xnew;
Tnew_o = [];

for lv = 1:LV
    w_o = W_o(:,lv); 
    p_o = P_o(:,lv);
    tnew_o = inv(w_o'*w_o)*Enew*w_o;
    
    Tnew_o = [Tnew_o tnew_o];
    Enew = Enew - tnew_o*p_o';
end

tnew = inv(w'*w)*Enew*w;
yhat = tnew*q;
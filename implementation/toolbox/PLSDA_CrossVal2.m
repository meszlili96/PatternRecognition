function [error_fraction]=PLSDA_CrossVal2(X,y,nlv,nvals,preprocessing,output);
%   in/out:
%   [error_fraction]=PLSDA_CrossVal2(X,y,nlv,nvals,preprocessing,output);
%
%   Cross validation to determine rank of PLS-DA models.
%   (GJP) Method applied is 'leave one randomly selected sample of each 
%   class out'. These 2 samples are used as test set (i.e. not stratified 
%   sampling). This is executed nvals times, errors are sampled and divided
%   by 2*nvals.
%   If requested the function produces a plot of the resulting CV errors
%   against the number of latent variables.
% 
%   (seems originating from:
%      [errorTOT,CV_Error_Sample]=PLSDA_CrossVal(X,y,nlv,nvals,preprocessing,output);)
%
% Output:
%   error_fraction      sum of errors (of both classes) divided by the number
%                       of cross validation loops
%   (removed output:
%        errorTOT            Total # of errors per # of LVs
%        CV_Error_Sample     # of errors per sample
%    )
%
% Input:
%   X                   data (no preprocessing)
%   y                   class (no preprocessing)
%   nlv                 maximum # of LVs for analysis
%   nvals               # of validations
%   preprocessing       Which preprocessing : 0=nothing, 1=mean centering, 
%                       2= autoscaling
%   output              0 if no plot, default is 1 : means yes
%
% 

if nargin < 6
    output = 1;
end

yun=unique(y);

iA=find(y==yun(1));
iB=find(y==yun(2));

errorA=zeros(nlv,1);
errorB=zeros(nlv,1);

CV_Error_Sample=zeros(size(X,1),1);

for ival=1:nvals
    if output~=0
        if round(ival/(nvals/10))-ival/(nvals/10)==0
            eval(['disp(''Evaluation ' num2str(ival) ' of ' num2str(nvals) ''')'])
        end
    end
   
    ioutA=randperm(length(iA));ioutB=randperm(length(iB));
    ioutA=ioutA(1);ioutB=ioutB(1);
    outA=iA(ioutA);outB=iB(ioutB);clear ioutA ioutB

    xoutA=X(outA,:);xoutB=X(outB,:);
    Xtest=[xoutA;xoutB];
    Xtrain=X;Xtrain([outA,outB]',:)=[];
    ytrain=y;ytrain([outA,outB]',:)=[];
    if preprocessing==1
        [Xtrainmc,xtrainmean]=mncn(Xtrain);
        [ytrainmc,ytrainmean]=mncn(ytrain);
    elseif preprocessing==2;
        % GJP [Xtrainmc,xtrainmean,xtrainstd]=auto(Xtrain);
        [Xtrainmc,xtrainmean,xtrainstd]=autosc(Xtrain);
        [ytrainmc,ytrainmean]=mncn(ytrain);
    % GJP    elseif preprocessing==3;
    %         [Xtrainmc,xtrainmean,xtrainstd]=pareto(Xtrain);
    %         [ytrainmc,ytrainmean]=mncn(ytrain);
    elseif preprocessing==0;
        Xtrainmc=Xtrain;xtrainmean=zeros(1,size(Xtrain,2));
        Ytrainmc=ytrain;ytrainmean=0;
    end

    % GJP as absent: [b1,ssq,p,q,w,t,u,bin] = pls(Xtrainmc,ytrainmc,nlv,0);
    % use now C1 version: [B, T, Uy, P, Q, W, R, Xvarnormperc, Yvarnormperc, A] = C1_PLSGJP(X, Y, LV)
    % (in this version B includes b0 and contains b as column vector for
    % each number of LVs.)
    [B, T, Uy, P, Q, W, R, Xvarnormperc, Yvarnormperc, A] = C1_PLSprins(Xtrainmc,ytrainmc,nlv);
    b1 = B(2:end,:)';

    % GJP commented as scale.m absent.
    % other lines added
    %     if preprocessing==1
    %         Xtestsc=scale(Xtest,xtrainmean);
    %     elseif preprocessing==2;
    %         Xtestsc=scale(Xtest,xtrainmean,xtrainstd);
    %     elseif preprocessing==3;
    %         Xtestsc=scale(Xtest,xtrainmean,xtrainstd);
    %     elseif preprocessing==0;
    %         Xtestsc=Xtest;
    %     end
    if preprocessing==1
        Xtestsc=Xtest-(ones(size(Xtest,1),1)*xtrainmean);
    elseif preprocessing==2;
        Xtestsc=(Xtest-(ones(size(Xtest,1),1)*xtrainmean))./(ones(size(Xtest,1),1)*xtrainstd);
    % GJP    elseif preprocessing==3;
    %         Xtestsc=scale(Xtest,xtrainmean,xtrainstd);
    elseif preprocessing==0;
        Xtestsc=Xtest;
    end
    
    
    for ilv=1:nlv;
        ypred=Xtestsc*b1(ilv,:)'+ytrainmean;
        distclass1=(yun-ypred(1)).^2;
        distclass2=(yun-ypred(2)).^2;
        if(distclass1(2)<=distclass1(1))
            errorA(ilv)=errorA(ilv)+1;
            CV_Error_Sample(outA)=CV_Error_Sample(outA)+1;
        end
        if(distclass2(1)<=distclass2(2))
            errorB(ilv)=errorB(ilv)+1;
            CV_Error_Sample(outB)=CV_Error_Sample(outB)+1;
        end
    end
end
   
error_fraction=(errorA+errorB)./(2*nvals);

if output~=0
    figure;hold on
    plot(error_fraction,'ro-')
    xlabel('# of LVs')
    ylabel('error fraction')
    title('PLS LV optimization through Cross Validation')
end

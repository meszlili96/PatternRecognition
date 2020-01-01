function [w_sig]=OPLSDA_jackknife2(X,y,nlv,ptol,nvals,nout,preprocessing,output);
% in/out:
%   [w_sig]=OPLSDA_jackknife2(X,y,nlv,ptol,nvals,nout,preprocessing,output);
%
%   Jackkniving to determine significant part of w of OPLS for given
%   number of latent variables and statistical significance, and plots 
%   result if requested.
%
% output:
%   w_sig               weight of every variable in jack knifed OPLS model
%
% input:
%   X                   data (no preprocessing)
%   y                   class (no preprocessing)
%   nlv                 number of LVs for analysis
%   ptol                p-value for significance test
%   nvals               number of validations (number of randomly selected Jackknife sets)
%   nout                number of samples to be taken out in order to produce 
%                       the jackknife sets (the same value is used for both classes)
%                       (this is one approach of producing these sets,
%                       other approaches are not implemented).
%   preprocessing       Which preprocessing? : 0=nothing, 1=mean centering, 
%                       2= autoscaling
%   output              output ? 0 if no

yun=unique(y);

iA=find(y==yun(1));
iB=find(y==yun(2));


%%  Construct Jack knifed w
for ival=1:nvals
    if output~=0
        if round(ival/(nvals/10))-ival/(nvals/10)==0
            eval(['disp(''Evaluation ' num2str(ival) ' of ' num2str(nvals) ''')'])
        end
    end
   
    ioutA=randperm(length(iA));ioutB=randperm(length(iB));ioutA=ioutA(1:nout);ioutB=ioutB(1:nout);
    outA=iA(ioutA);outB=iB(ioutB);clear ioutA ioutB

    xoutA=X(outA,:);xoutB=X(outB,:);
    Xtest=[xoutA;xoutB];
    Xtrain=X; Xtrain([outA,outB]',:)=[];
    ytrain=y; ytrain([outA,outB]',:)=[];
    if preprocessing==1
        [Xtrainmc,xtrainmean]=mncn(Xtrain);
        [ytrainmc,ytrainmean]=mncn(ytrain);
        
        [Xmc,xmean]=mncn(X);
        [ymc,ymean]=mncn(y);
    elseif preprocessing==2;
        [Xtrainmc,xtrainmean,xtrainstd]=autosc(Xtrain);
        [ytrainmc,ytrainmean]=mncn(ytrain);
        
        [Xmc,xmean,xstd]=autosc(X);
        [ymc,ymean]=mncn(y);
    elseif preprocessing==0;
        Xtrainmc=Xtrain;xtrainmean=zeros(1,size(Xtrain,2));
        Ytrainmc=ytrain;ytrainmean=0;
        
        Xmc=X;
        ymc=y;
    end

    [wnow] = OPLS(Xtrainmc,ytrainmc,nlv);
    w_jack(ival,:)=wnow';   
end

%%  Construct Confidence intervals for each w
[nsmps,nvars]=size(X);
w_jack_sort=sort(w_jack,1,'ascend');

smps=[round((ptol./2)*nvals),round((1-ptol./2)*nvals)];
w_ci=w_jack_sort(smps,:);
w_sig=sum(sign(w_ci))~=0;
[w_real] = OPLS(Xmc,ymc,nlv);

%%  Plot output
if output==1
    figure;hold on
    bar([1:nvars],w_real)
    plot([1:nvars],w_ci(2,:),'kv','markerfacecolor','k')
    plot([1:nvars],w_ci(1,:),'k^','markerfacecolor','k')
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

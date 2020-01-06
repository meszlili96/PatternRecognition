function [sFeat,curve] = ga(samples,countries,values, lvs, N,T,CR,MR)
%---Inputs-----------------------------------------------------------------
% feat:  features
% label: labelling
% lvs: number of latent variables
% N:     Polulation size
% T:     Maximum number of generations
% CR:    Crossover rate
% MR:    Mutation rate
%---Outputs----------------------------------------------------------------
% sFeat: Selected features
% Sf:    Selected feature index
% Nf:    Number of selected features
% curve: Convergence curve
%--------------------------------------------------------------------------

% Number of dimensions
D=size(values,2);
% Initial population
X=[]; fit=zeros(1,N);
for i=1:N
    Xn = [];
    while length(Xn) < lvs
        feature_num = randi([1 D],1,1);
        if ~ismember(feature_num,Xn)
            Xn = [Xn, feature_num];
        end
    end
    X = [X; Xn];
end
% Fitness 
for i=1:N
  fit(i)=lda_error(samples,countries,values,X(i,:));
end
% Pre
curve=inf; t=1; 
figure(1); clf; axis([1 100 0 T]); xlabel('Number of Iterations');
ylabel('Fitness Value'); title('Convergence Curve'); grid on;
%---Generations start------------------------------------------------------
while t <= T
	% Convert error to accuracy (inverse of fitness)
  Ifit=1-fit;
  % Get probability
  Prob=Ifit/sum(Ifit);
  % {1} Crossover 
  X1=[]; X2=[]; z=1;
  for i=1:N
    if rand() < CR
      % Select two parents 
      k1=jRouletteWheelSelection(Prob); k2=jRouletteWheelSelection(Prob);
      % Store parents 
      P1=X(k1,:); P2=X(k2,:);
      % Random select one crossover point
      ind=randi([1,lvs]);
      % Single point crossover between 2 parents
      X1z=[P1(1:ind),P2(ind+1:lvs)]; 
      X1z = unique(X1z,'stable');
      X2z=[P2(1:ind),P1(ind+1:lvs)]; z=z+1; 
      X2z = unique(X2z,'stable');
      
      % if crossover resulted in chromosomes with duplicated values, add
      % random ferture numbers to make chromosomes length = lvs
      while length(X1z) < lvs
        feature_num = randi([1 D],1,1);
        if ~ismember(feature_num,X1z)
            X1z = [X1z, feature_num];
        end
      end
      
      while length(X2z) < lvs
        feature_num = randi([1 D],1,1);
        if ~ismember(feature_num,X2z)
            X2z = [X2z, feature_num];
        end
      end
      
      X1 = [X1; X1z];
      X2 = [X2; X2z];
    end
  end
  % Union
  Xnew=[X1;X2]; Nc=size(Xnew,1); Fnew=zeros(1,Nc);
  % {2} Mutation
  for i=1:Nc
    for d=1:lvs
      if rand() <= MR
        % Mutate by addition of a random number in [-10, 10] interval
        cand = -1;
        while cand < 1 || cand > D || ismember(cand, Xnew(i,:))
            shift = randi([-10 10],1,1);
            cand = Xnew(i,d) + shift;
        end
        Xnew(i,d)=cand;
      end
    end
    % Fitness 
    Fnew(i)=lda_error(samples,countries,values,Xnew(i,:));
  end 
  % Merge population
  XX=[X;Xnew]; FF=[fit,Fnew]; 
  % Select N best solution 
  [FF,idx]=sort(FF); X=XX(idx(1:N),:); fit=FF(1:N); 
  % Best chromosome
  Xgb=X(1,:); fitG=fit(1); curve(t)=fitG;
  fprintf('Iteration %.4f best error rate %.4f ', t, fitG);
  fprintf('\n ');
  % Plot convergence curve
  pause(0.000000001); hold on;
  CG=plot(t,fitG,'Color','r','Marker','.'); set(CG,'MarkerSize',5);
  t=t+1;
end
% Select features based on selected index
sFeat=Xgb; 
end

%---Call Function----------------------------------------------------------
function Route=jRouletteWheelSelection(Prob)
% Cummulative summation
C=cumsum(Prob);
% Random one value, most probability value [0~1]
P=rand();
% Route wheel
for i=1:length(C)
	if C(i) > P
    Route=i; break;
  end
end

end


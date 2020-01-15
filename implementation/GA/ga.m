function [sFeat,curve] = ga(validation,samples,values,countries, lvs, N,T,CR,MR, plot)
%---Inputs-----------------------------------------------------------------
% validation: validation subset
% samples: training samples
% countries: known countries codes
% values: training data set
% lvs: number of latent variables to use in chromosomes
% N:     Polulation size
% T:     Maximum number of generations
% CR:    Crossover rate
% MR:    Mutation rate
% plot:  boolean, true - default
%---Outputs----------------------------------------------------------------
% sFeat: Selected features
% curve: Convergence curve
%--------------------------------------------------------------------------

if nargin == 8
  plot = 1;
end

% difference rate to terminate when error reached 0
diff_rate = 0.01;
% Number of dimensions
D=size(values,2);
% Initial population. N randomly generated subsets of features of lvs size 
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
  fit(i)=lda_error(validation,samples,countries,values,X(i,:));
end

curve=inf; t=1; 
if plot
    figure(1); clf; axis([1 100 0 T]); xlabel('Number of Iterations');
    ylabel('Fitness Value'); title('Convergence Curve'); grid on;
end
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
      % Random select two crossover points
      ind1=randi([1,lvs]); ind2 = ind1;
      while abs(ind1 - ind2)<2
          ind2=randi([1,lvs]);
      end
      ind = sort([ind1, ind2]);
      % Two points crossover between 2 parents
      X1z=[P1(1:ind(1)),P2(ind(1)+1:ind(2)),P1(ind(2)+1:lvs)]; 
      X1z = unique(X1z,'stable');
      X2z=[P2(1:ind(1)),P1(ind(1)+1:ind(2)),P2(ind(2)+1:lvs)];
      X2z = unique(X2z,'stable');
      z=z+1;
      % if crossover resulted in chromosomes with duplicated values, add
      % random feature numbers to make chromosomes length = lvs
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
        % Checking that variable number is not outside of a valid interval
        cand = -1;
        while cand < 1 || cand > D || ismember(cand, Xnew(i,:))
            shift = randi([-10 10],1,1);
            cand = Xnew(i,d) + shift;
        end
        Xnew(i,d)=cand;
      end
    end
    % Fitness 
    Fnew(i)=lda_error(validation,samples,countries,values,Xnew(i,:));
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
  if plot
    pause(0.000000001); hold on;
    CG=plot(t,fitG,'Color','r','Marker','.'); set(CG,'MarkerSize',5);
  end
  if curve(t) < diff_rate
      fprintf('Converged, Iteration %.4f', t);
      fprintf('\n ');
      break;
  end
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


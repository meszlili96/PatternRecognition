function [B, T, Uy, P, Q, W, R, Xvarnormperc, Yvarnormperc, A] = C1_PLSprins(X, Y, LV);
%
%  
%  [B, T, Uy, P, Q, W, R, Xvarnormperc, Yvarnormperc, A] = C1_PLSprins(X, Y, LV)
%
% Partial Least Squares
%
%
% INPUT:    
%   X     - Data matrix X
%   Y     - Dependent variable Y (one column assumed)
%   LV    - Number of latent variables
%
%
% OUTPUT:
%   B     - Regression coefficients
% 
% GJP 3/2010 extended: more output:
%   [B, T, Uy, P, Q, W, R, Xvarnormperc, Yvarnormperc, A]
%   T     - (X) scores
%   Uy    - Y scores (U = Y*Q)
%   P     - (X) loadings
%   Q     - Y loadings (see literature)
%   W     - W matrix (see literature)
%   R     - R matrix (generalized inverse of P'): T = X*R
%   A     - A matrix: the regression coefficients based on T (Y = T*A)
%
% GJP 4/2010: also variance out: the explained variance for each LV as
% percentage of the total amount of variance in X (resp. Y).
% 
% GJP: mean centering of X should be done outside of routine, because mean
% should be used in case of prediction to correct test data. See e.g.
% C1_PLSpred.m !! Y does not need to be centered.
%
% 4/2011: A as extra last output added for check of influence on B

% Xmncn = mncn(X);
Xmncn = X;

E = Xmncn;
F = Y;

for LV_nr = 1:LV
    % LV_nr
    S = E' * F;
    [U, D, V] = svd(S, 0);
    
    w = U(:,1);
    t = E * w;
    p = E' * t / (t' * t);
    q = F' * t / (t' * t);
    
    W(:,LV_nr) = w;
    T(:,LV_nr) = t;
    P(:,LV_nr) = p;
    Q(:,LV_nr) = q;
    
    E = E - (t * p');
    F = F - (t * q');
    
    R = W * inv(P' * W);
    % MLR/PCR Regression on the scores t: Y=T*A, so
    A = inv(T' * T) * T' * Y;
    
    b1 = R * A;
    
    meanY = mean(Y);
    
    b0 = meanY - mean(Xmncn * b1);
    
    B(:,LV_nr) = [b0 ; b1];
    
    % GJP: for explained var calculation:
    ssq(LV_nr,1) = sum(sum((t * p').^2)');
    % GJP July 2010: this calculation does NOT work if X-data are NOT
    % mean-centered. 
    % GJP July 2010: ssq(LV_nr,2) = sum(sum(((t * p') * b1).^2)')
    ssq(LV_nr,2) = sum(sum((((t * p') * b1) - mean((t * p') * b1)).^2)');
end

Uy = Y * Q;

% GJP 9/4/2010: explained variance calc:
ssqx    = sum(sum(X.^2)');
ssqy    = sum(sum((Y - ones(size(Y,1),1)*meanY).^2)');
ssq(:,1) = ssq(:,1)*100/ssqx;
ssq(:,2) = ssq(:,2)*100/ssqy;
Xvarnormperc = ssq(:,1)';
Yvarnormperc = ssq(:,2)';
% cumulative sum can be calculated with cumsum. Skipped

return

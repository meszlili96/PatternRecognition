function [w,t,p,q,T_o,P_o,W_o] = OPLS(X,y,LV);

%
%   [w,t,p,q,T_o,P_o,W_o] = OPLS(X,y,LV);
%
% INPUT:    
%   X     - Data matrix X (mean centred)
%   Y     - Dependent variable Y (one column assumed, mean centred)
%   LV    - Number of latent variables
%
% OUTPUT:
%   w     - (first) most y-related loading vector
%   t     - (first) most y-related scores
%   p     - (first) most y-related p loading vector (see literature)
%   q     - (first) y loading vector (see literature)
%   T_o   - Y-orthogonal scores
%   P_o   - Y-orthogonal loading vectors
%   W_o   - Y-orthogonal W-loading vectors
%
% Johan Westerhuis
% Biosystems Data Analysis
% University of AMsterdam
%
% LV orthogonal components are calculated after which 1 predictive
% component is calculated.
%
% Mean centering of X and Y should be done outside of this routine.
% 
% Completed by GJ Postma 12/2012

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

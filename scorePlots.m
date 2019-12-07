% values_mncn: mean centred data matrix
% countries: dependent variable
% 4: number of latent variables from LVNumber result
[values_mncn, values_mean]=mncn(values);
[w,T,p,q,T_o,P_o,W_o] = OPLS(values_mncn,countries,4);


gscatter(T,T_o(:,1),countries);
legend({'Greece','Italy','Portugal','Spain'},'Location','southwest');
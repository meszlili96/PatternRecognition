% values_mncn: mean centred data matrix
% countries: dependent variable
% 4: number of latent variables from LVNumber result

[values_mncn, values_mean]=mncn(values);

countriesUnique=unique(countries);

for i=1:length(countriesUnique)
    country=double(countries==countriesUnique(i));
    [w,T,p,q,T_o,P_o,W_o] = OPLS(values_mncn',country,4);
    figure
    gscatter(T,T_o(:,1),country);
    legend({char(Data.country(i)),'Rest'});
end

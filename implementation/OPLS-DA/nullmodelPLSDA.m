%for i=1:length(countriesUnique)
    country=double(countries==countriesUnique(1));
 %   figure
    [pvar,p_model]=PLSDA_NullModel2(values',country,LV,0.05,100,100,1,1);
%end

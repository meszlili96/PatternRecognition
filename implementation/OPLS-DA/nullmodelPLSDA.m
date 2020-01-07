%OPLSDA_2cv2 only works for 2 classes
for i=1:length(countriesUnique)
    country=double(countries==countriesUnique(i));
    [pvar,p_model]=PLSDA_NullModel2(values',country,LV,0.05,100,100,1,1);
end

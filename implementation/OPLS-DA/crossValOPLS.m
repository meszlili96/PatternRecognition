[validationSet, testSet]=splitData(samples, countries);
entireTestSet = getAllSamplesIndexes(samples, testSet);
entireValidationSet = getAllSamplesIndexes(samples, validationSet);

N=length(countriesUnique);
MissClass_2cv=zeros(N,1);
Q2_2cv=zeros(N,1);
RP=zeros(N,1);

for i=1:N
    country=double(countries==countriesUnique(1));
    [MissClass_2cv(i),Q2_2cv(i),RP(i),T_final]=OPLSDA_2cv2(values',country,4,entireTestSet,0);
end
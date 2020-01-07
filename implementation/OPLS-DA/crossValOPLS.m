N=length(countriesUnique);
MissClass_2cv=zeros(N,1);
Q2_2cv=zeros(N,1);
RP=zeros(N,1);

for i=1:N
    country=double(countries==countriesUnique(1));
    entireTestSet = [];
    for j=1:5
        [validationSet, testSet]=splitData(samples, countries);
        entireTestSet = [entireTestSet; getAllSamplesIndexes(samples, testSet)];
    end
    %max number of LVs is 8
    [MissClass_2cv(i),Q2_2cv(i),RP(i),T_final]=OPLSDA_2cv2(values',country,8,entireTestSet,0);
end
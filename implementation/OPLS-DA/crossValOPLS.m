countriesUnique=unique(countries);
N=length(countriesUnique);
MissClass_2cv=zeros(N,1);
Q2_2cv=zeros(N,1);
RP=zeros(N,1);
LV=8;

for i=1:N
    country=double(countries==countriesUnique(1));
    entireTestSet = [];
    entireValidSet = [];
    for j=1:5
        [validationSet, testSet]=splitData(samples, countries);
        entireValidSet = [entireValidSet; getAllSamplesIndexes(samples, validationSet)];
        entireTestSet = [entireTestSet; getAllSamplesIndexes(samples, testSet)];
    end
    scorePlots(values(:,entireTestSet(1,:)),country(entireTestSet(1,:)),values(:,entireValidSet(1,:)),country(entireValidSet(1,:)),LV,char(Data.country(i)));
    %max number of LVs is 8
    [MissClass_2cv(i),Q2_2cv(i),RP(i),T_final]=OPLSDA_2cv2(values',country,LV,entireTestSet,0);
end
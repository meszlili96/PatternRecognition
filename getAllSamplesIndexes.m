function [samplesIndexes] = getAllSamplesIndexes(samples, sampleIds)
%   extracts the indexes of objects with the given Ids
%   sampleIds - array of unique ids of samples
%   samples - array of samples which may contain duplicates
%
%   output:
%   samplesIndexes - indexes of object in samples with ids from sampleIds
N = length(samples);
samplesIndexes = [];
for i=1:N
    sampleNumber = samples(i);
    if ismember(sampleNumber, sampleIds)
        samplesIndexes = [samplesIndexes i];
    end
end
end


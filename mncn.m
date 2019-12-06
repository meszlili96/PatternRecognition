function [mncnData] = mncn(data, means)
% mean center data
%   data - data set witn samples in rows and variables in columns
%   means - means to use (for cross validation)
[N,~] = size(data);

if nargin == 1
  means = mean(data);
end

mncnData = data - means(ones(N,1),:);
end


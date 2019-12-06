function [filteredByCountry] = dataForCountry(data, countries, countryCode)
% Returns the data for one country only
%   data - whole dataset
%   countries - country codes for samples
%   countryCode - country code to leave
neededCountry = (countries == countryCode);
filteredByCountry = data(neededCountry,:);
end


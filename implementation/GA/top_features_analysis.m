% best solution analysis
clear;
addpath '../preprocess';
load('../data/oils.mat')
countries = Data.countries;
values = Data.values;
wavelength = Data.wavelength;

mncnValues = mncn2(values);
best_solution = load('best_solution.txt', '-ASCII');
N = length(best_solution);

% Greece
greeceData = dataForCountry(mncnValues, countries, 1);
plotSpectrum(mean(greeceData), wavelength);
title('Greece')
xlabel('Wavelengths numbers');
ylabel('Mean absorbance units');
for i=1:N
    xline(wavelength(best_solution(i)),'--k');
end

% Italy
italyData = dataForCountry(mncnValues, countries, 2);
plotSpectrum(mean(italyData), wavelength);
title('Italy')
xlabel('Wavelengths numbers');
ylabel('Mean absorbance units');
for i=1:N
    xline(wavelength(best_solution(i)),'--k');
end

% Portugal
portugalData = dataForCountry(mncnValues, countries, 3);
plotSpectrum(mean(portugalData), wavelength);
title('Portugal')
xlabel('Wavelengths numbers');
ylabel('Mean absorbance units');
for i=1:N
    xline(wavelength(best_solution(i)),'--k');
end

% Spain
spainData = dataForCountry(mncnValues, countries, 4);
plotSpectrum(mean(spainData), wavelength);
title('Spain')
xlabel('Wavelengths numbers');
ylabel('Mean absorbance units');
for i=1:N
    xline(wavelength(best_solution(i)),'--k');
end


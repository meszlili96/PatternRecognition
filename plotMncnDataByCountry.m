
load('oils.mat')

countries = Data.countries;
values = Data.values;
wavelength = Data.wavelength;

% Greece
greeceData = dataForCountry(values, countries, 1);
plotSpectrum(mncn(greeceData), wavelength);

% Italy
italyData = dataForCountry(values, countries, 2);
plotSpectrum(mncn(italyData), wavelength);

% Portugal
portugalData = dataForCountry(values, countries, 3);
plotSpectrum(mncn(portugalData), wavelength);

% Spain
spainData = dataForCountry(values, countries, 4);
plotSpectrum(mncn(spainData), wavelength);

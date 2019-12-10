
load('oils.mat')

countries = Data.countries;
values = Data.values;
wavelength = Data.wavelength;

% Greece
greeceData = dataForCountry(values, countries, 1);
plotSpectrum(mncn2(greeceData), wavelength);
title('Greece')

% Italy
italyData = dataForCountry(values, countries, 2);
plotSpectrum(mncn2(italyData), wavelength);
title('Italy')

% Portugal
portugalData = dataForCountry(values, countries, 3);
plotSpectrum(mncn2(portugalData), wavelength);
title('Portugal')

% Spain
spainData = dataForCountry(values, countries, 4);
plotSpectrum(mncn2(spainData), wavelength);
title('Spain')

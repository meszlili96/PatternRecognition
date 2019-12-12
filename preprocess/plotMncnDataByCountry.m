
load('oils.mat')

countries = Data.countries;
values = Data.values;
wavelength = Data.wavelength;

mncnValues = mncn2(values);

% Greece
greeceData = dataForCountry(mncnValues, countries, 1);
plotSpectrum(greeceData, wavelength);
title('Greece')

% Italy
italyData = dataForCountry(mncnValues, countries, 2);
plotSpectrum(italyData, wavelength);
title('Italy')

% Portugal
portugalData = dataForCountry(mncnValues, countries, 3);
plotSpectrum(portugalData, wavelength);
title('Portugal')

% Spain
spainData = dataForCountry(mncnValues, countries, 4);
plotSpectrum(spainData, wavelength);
title('Spain')

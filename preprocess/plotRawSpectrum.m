
load('oils.mat')

wavelength = Data.wavelength;
samples = Data.samples;
values = Data.values;

plotSpectrum(values, wavelength);

xlim([800 1900]);
ylim([0 1.6]);


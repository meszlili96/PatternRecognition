
load('oils.mat')

wavelength = Data.wavelength;
samples = Data.samples;
values = Data.values;

plotSpectrum(values, wavelength);
ylim([0 1.6]);


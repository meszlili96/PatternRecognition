% plots raw spectra of all samples
clear;
load('../data/oils.mat')

wavelength = Data.wavelength;
samples = Data.samples;
values = Data.values;

plotSpectrum(values, wavelength);
xlabel('Wavelengths numbers');
ylabel('Absorbance units');
ylim([0 1.6]);


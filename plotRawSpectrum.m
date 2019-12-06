
load('oils.mat')

wavelength = Data.wavelength;
samples = Data.samples;
values = Data.values;

N = length(samples);
M = length(wavelength);

figure()
for i = 1:N
    % get wavelengths for i_th sample
    sampleWavelengths = values(i,:);
    plot(wavelength, sampleWavelengths, 'b');
    hold on
end

xlim([800 1900]);
ylim([0 1.6]);

hold off

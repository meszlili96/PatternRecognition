function [] = plotSpectrum(data, wavelength)
%   plots spectrum
%   data - data set witn samples in rows and variables in columns
[N, ~] = size(data);
figure()
for i = 1:N
    % get wavelengths for i_th sample
    sampleWavelengths = data(i,:);
    plot(wavelength, sampleWavelengths, 'b');
    hold on
end

xlim([800 1900])

hold off
end


function [] = plotSpectrum(data, wavelength)
%   plots spectrum
%   data - data set witn samples in rows and variables in columns
[N, ~] = size(data);
figure('DefaultAxesFontSize', 14)
for i = 1:N
    % get wavelengths for i_th sample
    sampleWavelengths = data(i,:);
    plot(wavelength, sampleWavelengths);
    hold on
end

xlim([800 1900])
end


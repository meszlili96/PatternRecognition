% top features analysis
clear
load('../data/oils.mat')
wavelengths = Data.wavelength;

top_features = load('top_features.txt', '-ASCII');
occurences = load('features_occurences.txt', '-ASCII');

top_wavelengths = wavelengths(top_features);

fprintf('Top wavelengths \n');
disp(top_wavelengths);

top_features_occurences = occurences(top_features);
fprintf('Top wavelengths occurences \n');
disp(top_features_occurences);
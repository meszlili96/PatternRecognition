# Implementation details

### data folder
Olive oils data in .csv and .mat format

### preprocess folder
Also contains logic for double-CV. Most functions are needed to obtain proper separation into test, training and validation sets. Each script or function is documented. Run the following scripts to reproduce the results described in the report:
- plotRawSpectrum.m - to plot raw spectra of all oil samples
- plotMncnDataByCountry.m - to plot mean-centred spectra by country
- pca_analysis.m - to perform PCA analysis

### GA folder
Genetic algorithm implementation and code for analysis of the results. Each script or function is documented. Run the following scripts to reproduce the results described in the report (due to different possible separation into test, training and validation sets the results may be slightly different):
- ga_main.m - script that runs the GA with the specified parameters and saves the results to files. Running of this script will overwrite 'features.txt' and 'ga_error_rates.txt'!
- lda_with_ga_results.m - evaluation and saving of GA results to select the best zero error rate solution obtained on the previous step with ga_main.m. Running of this script will overwrite 'best_solution.txt'!
- best_solution_analysis.m - plots the wavelengths from the best solution on the averaged spectrum of each country. 
- results folded contains the results described in the report

### OPLS-DA folder
The code for OPLS-DA implementation and analysis

### toolbox folder
auxiliary scripts used in OPLS-DA

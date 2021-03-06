% a script to convert the data in .csv fromat to matlab format
clear;
A = readtable('../data/FTIR_Spectra_olive_oils.csv');
A = A{:,:};
nrow=size(A,1)-3;
ncol=size(A,2)-1;
values=zeros(nrow,ncol);
wavelength=zeros(nrow,1);
samples=zeros(ncol,1);
countries=zeros(ncol,1);

country=unique(A(3,2:end));

for j=2:size(A,2)
    if strcmp(cell2mat(A(3,j)), 'Greece')
        countries(j-1)=1;
    elseif strcmp(cell2mat(A(3,j)), 'Italy')
        countries(j-1)=2;
    elseif strcmp(cell2mat(A(3,j)), 'Portugal')
        countries(j-1)=3;
    elseif strcmp(cell2mat(A(3,j)), 'Spain')
        countries(j-1)=4;
    end
    samples(j-1) = str2double(cell2mat(A(1,j)));
end

for i=4:size(A,1)
    wavelength(i-3)=str2double(cell2mat(A(i,1)));
    for j=2:size(A,2)
        values(i-3,j-1)=str2double(cell2mat(A(i,j)));
    end
end

Data.wavelength = transpose(wavelength);
Data.values = transpose(values);
Data.samples = samples;
Data.countries = countries;
Data.country = country;

A = readtable('FTIR_Spectra_olive_oils.csv');
A = A{:,:};
nrow=size(A,1)-3;
ncol=size(A,2)-1;
values=zeros(nrow,ncol);
wavelength=zeros(nrow,1);
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
end

for i=4:size(A,1)
    wavelength(i-3)=str2double(cell2mat(A(i,1)));
    for j=2:size(A,2)
        values(i-3,j-1)=str2double(cell2mat(A(i,j)));
    end
end

s.wavelength = transpose(wavelength);
s.values = transpose(values);
s.countries = countries;
s.country = country;

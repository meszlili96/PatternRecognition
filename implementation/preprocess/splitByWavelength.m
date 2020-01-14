wavelengthValues1=[];
wavelengthValues2=[];
for i=1:570
   if (wavelength(i) < 1050)
       wavelengthValues1 = [wavelengthValues1; values(i,:)];
   end
   if (wavelength(i) < 1700 && wavelength(i) > 950)
       wavelengthValues2 = [wavelengthValues2; values(i,:)];
   end
end
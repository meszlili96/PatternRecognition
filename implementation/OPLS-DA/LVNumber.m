% data: values
% class: countries
% 8 LVs fr analysis
% 200 validations
% preprocessing: mean centering
% plot result
[error_fraction_OPLSDACV2]=OPLSDA_CrossVal2(wavelengthValues1',countries,8,200,1,1);
[error_fraction_OPLSDACV2]=OPLSDA_CrossVal2(wavelengthValues2',countries,8,200,1,1);
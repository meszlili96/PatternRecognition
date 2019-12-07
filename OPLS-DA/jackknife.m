%   X                   data (no preprocessing)
%   y                   class (no preprocessing)
%   nlv                 number of LVs for analysis
%   ptol                p-value for significance test
%   nvals               number of validations (number of randomly selected Jackknife sets)
%   nout                number of samples to be taken out in order to produce 
%                       the jackknife sets (the same value is used for both classes)
%                       (this is one approach of producing these sets,
%                       other approaches are not implemented).
%   preprocessing       Which preprocessing? : 0=nothing, 1=mean centering, 
%                       2= autoscaling
%   output              output ? 0 if no
[w_sig]=OPLSDA_Jackknife2(values,countries,4,0.05,20,8,1,1);
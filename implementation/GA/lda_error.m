function [error_rate] = lda_error(validation,samples,countries,values,variables)
%   GA fitness function. Generates subset of data set based on selected
%   features and calls loo_cv()
%---Inputs-----------------------------------------------------------------
% validation: validation samles numbers
% samples: all samples
% countries: countries codes
% values: the whole data set
% variables: features to select
%---Outputs----------------------------------------------------------------
% average_error: average error
%--------------------------------------------------------------------------

selected_variables = values(:,variables);
error_rate = loo_cv(validation,samples,countries,selected_variables);
end


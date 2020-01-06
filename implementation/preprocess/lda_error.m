function [error_rate] = lda_error(samples,countries,values,variables)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

selected_values = values(:,variables);
if length(variables) > size(values,1)
    fprintf('%.4f ', length(variables));
end

error_rate = doubleCV(samples,countries,selected_values);
end


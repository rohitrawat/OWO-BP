function [Wo Wi] = mlp_integrate_input_means_into_weights(Wo, Wi, input_means)
% Merges the input means into thresholds, so means don't have to be subtracted form the
% validation file during processing.
% Assuming the constant basis function is the first input.
% Returns the updated Wo and Wi matrices.

N = length(input_means);
cascade = mlp_isCascade(Wi, Wo);
if(cascade == false)
    Wo(:,1) = Wo(:,1) - Wo(:, 2:N+1) * input_means';
end
Wi(:,1) = Wi(:,1) - Wi(:, 2:N+1) * input_means';

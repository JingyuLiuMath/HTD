function [Ak, permute_order] = Unfolding(A, k)
% Unfolding

% Jingyu Liu, May 9, 2024.

arguments (Input)
    A double;
    k (1, 1) double;
end

arguments (Output)
    Ak (:, :) double;
    permute_order (1, :) double;
end

d = ndims(A);

% Permute.
rest_dim = [1 : (k - 1), (k + 1) : d];
permute_order = [k, rest_dim];

% Reshape.
Ak = permute(A, permute_order);
Ak = reshape(Ak, size(A, k), prod(size(A, rest_dim)));

end
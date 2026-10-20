function [Q, k] = ColBasis(B, k)
% ColBasis

% Jingyu Liu, December 4, 2024.

arguments (Input)
    B (:, :) double;
    k (1, 1) double
end

arguments (Output)
    Q (:, :) double;
    k (1, 1) double;
end

[Q, R, ~] = qr(B, "econ", "vector");

k = min(find(abs(diag(R)) >= 1e-15, 1, "last"), k);

Q = Q(:, 1 : k); 

end
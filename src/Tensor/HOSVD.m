function [G, U, r] = HOSVD(A, rank_or_tol)
% HOSVD Computing the Tucker decomposition of a tensor by high order SVD.

% Jingyu Liu, May 9, 2024.

% If rank_or_tol >= 1, it is treated as target rank. Otherwise it is
% treated as relative tolerance.

arguments (Input)
    A double;
    rank_or_tol (1, 1) double;
end

arguments (Output)
    G double;
    U (1, :) cell;
    r (1, :) double;
end

d = ndims(A);
U = cell(1, d);

for k = 1 : d
    [U{k}, ~, ~] = MySVDSketch(Unfolding(A, k), rank_or_tol);
end

G = A;
for k = 1 : d
    G = TenMultMat(G, U{k}', k);
end
r = size(G);

end
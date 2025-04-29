function [G, U, r] = RHOSVD(A, rank_or_tol, power_iter)
% RHOSVD

% Jingyu Liu, May 9, 2024.

% If rank_or_tol >= 1, it is treated as target rank. Otherwise it is
% treated as relative tolerance.

arguments (Input)
    A double;
    rank_or_tol (1, 1) double;
    power_iter (1, 1) double = 0;
end

arguments (Output)
    G double;
    U (1, :) cell;
    r (1, :) double;
end

d = ndims(A);
U = cell(1, d);

if rank_or_tol >= 1
    for k = 1 : d
        [Q, ~] = RangeFinder(Unfolding(A, k), rank_or_tol, power_iter);
        U{k} = Q(:, 1 : rank_or_tol);
    end
else
    for k = 1 : d
        [U{k}, ~] = RangeFinder(Unfolding(A, k), rank_or_tol, power_iter);
    end
end

G = A;
for k = 1 : d
    G = TenMultMat(G, U{k}', k);
end
r = size(G, 1 : d);

end
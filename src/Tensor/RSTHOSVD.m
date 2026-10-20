function [G, U, r] = RSTHOSVD(A, rank_or_tol, power_iter)
% RSTHOSVD

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

[~, process_order] = sort(size(A), "descend");
d = ndims(A);
U = cell(1, d);
G = A;
for k = 1 : d
    pk = process_order(k);
    Upk = RangeFinder(Unfolding(G, pk), rank_or_tol, power_iter);
    if rank_or_tol >= 1
        Upk = Upk(:, 1 : rank_or_tol);
    end
    U{pk} = Upk;
    G = TenMultMat(G, Upk', pk);
end
r = size(G, 1 : d);

end
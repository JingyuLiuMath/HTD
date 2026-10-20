function [G, U, r] = STHOSVD(A, rank_or_tol)
% STHOSVD

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

[~, process_order] = sort(size(A), "ascend");
d = ndims(A);
U = cell(1, d);
G = A;
for k = 1 : d
    pk = process_order(k);
    [Upk, ~, ~] = MySVDSketch(Unfolding(G, pk), rank_or_tol);
    U{pk} = Upk;
    G = TenMultMat(G, Upk', pk);
end
r = size(G, 1 : d);

end
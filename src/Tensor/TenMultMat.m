function B = TenMultMat(A, U, k)
% TenMultMat

% Jingyu Liu, May 9, 2024.

arguments (Input)
    A double;
    U (:, :) double;
    k (1, 1) double;
end

arguments (Output)
    B double;
end

B = ipermute(...
    tensorprod(U, A, 2, k), ...
    [k, 1 : (k - 1), (k + 1) : ndims(A)]);

end
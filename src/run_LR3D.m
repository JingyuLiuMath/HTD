function result = run_LR3D(A, U_svd, S_svd, V_svd, B_x, B_y, k_fun, r)
% run_LR3D evaluates one 3D low-rank order.

R = r^3;
indR = 1 : R;
Aapprox = U_svd(:, indR) * S_svd(indR, indR) * V_svd(:, indR)';
svd_err = norm(Aapprox - A, "fro") / norm(A, "fro");

[U1, U2, U3, G, V1, V2, V3] = TLR_Chebyshev3D(B_x, B_y, k_fun, r);
Aapprox = kron(U3, kron(U2, U1)) ...
    * reshape(G, [r^3, r^3]) ...
    * kron(V3, kron(V2, V1)).';
inter_err = norm(Aapprox - A, "fro") / norm(A, "fro");

[U1, U2, U3, G, V1, V2, V3] = TLR_SVD3D(B_x, B_y, k_fun, r);
Aapprox = kron(U3, kron(U2, U1)) ...
    * reshape(G, [r^3, r^3]) ...
    * kron(V3, kron(V2, V1)).';
tsvd_err = norm(Aapprox - A, "fro") / norm(A, "fro");

result.svd_err = svd_err;
result.inter_err = inter_err;
result.tsvd_err = tsvd_err;

end

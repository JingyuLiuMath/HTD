function result = run_LR2D(A, U_svd, S_svd, V_svd, B_x, B_y, k_fun, r)
% run_LR2D evaluates one 2D low-rank order.

R = r^2;
indR = 1 : R;
Aapprox = U_svd(:, indR) * S_svd(indR, indR) * V_svd(:, indR)';
svd_err = norm(Aapprox - A, "fro") / norm(A, "fro");

[U1, U2, G, V1, V2] = TLR_Chebyshev2D(B_x, B_y, k_fun, r);
Aapprox = kron(U2, U1) * reshape(G, [r^2, r^2]) * kron(V2, V1).';
inter_err = norm(Aapprox - A, "fro") / norm(A, "fro");

[U1, U2, G, V1, V2] = TLR_SVD2D(B_x, B_y, k_fun, r);
Aapprox = kron(U2, U1) * reshape(G, [r^2, r^2]) * kron(V2, V1).';
tsvd_err = norm(Aapprox - A, "fro") / norm(A, "fro");

result.svd_err = svd_err;
result.inter_err = inter_err;
result.tsvd_err = tsvd_err;

end

clear;
close all;

global_size = 128;
h = 1 / global_size;
n = 32;

I1_x = Interval(global_size, 1, n);
I2_x = Interval(global_size, 1, n);
B_x = Box2D(I1_x, I2_x);
x_points = B_x.Points();

I1_y = Interval(global_size, 2 * n + 1, 3 * n);
I2_y = Interval(global_size, 1, n);
B_y = Box2D(I1_y, I2_y);
y_points = B_y.Points();

k_fun = @(xx, yy) SLP2D(xx, yy, 0);

r_list = 1 : 16;
num_r = length(r_list);

A = k_fun(x_points, y_points);

[U_svd, S_svd, V_svd] = svd(A);

for it_r = 1 : num_r
    r = r_list(it_r);
    R = r^2;
    indR = 1 : R;
    Aapprox = U_svd(:, indR) * S_svd(indR, indR) * V_svd(:, indR)';
    svd_err = norm(Aapprox - A, "fro") / norm(A, "fro");

    [U1, U2, G, V1, V2] = TLR_Chebyshev2D(B_x, B_y, k_fun, r);
    Aapprox = kron(U2, U1) * reshape(G, [r^2, r^2]) * kron(V2, V1)';
    inter_err = norm(Aapprox - A, "fro") / norm(A, "fro");

    [U1, U2, G, V1, V2] = TLR_SVD2D(B_x, B_y, k_fun, r);
    Aapprox = kron(U2, U1) * reshape(G, [r^2, r^2]) * kron(V2, V1)';
    tsvd_err = norm(Aapprox - A, "fro") / norm(A, "fro");

    file_name = "./data/WS_SLP/LR_" + string(r) + ".mat";
    save(file_name, "svd_err", "inter_err", "tsvd_err");
end

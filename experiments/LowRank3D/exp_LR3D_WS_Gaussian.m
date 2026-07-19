clear;
close all;

global_size = 64;
h = 1 / global_size;
n = 16;

I1_x = Interval(global_size, 1, n);
I2_x = Interval(global_size, 1, n);
I3_x = Interval(global_size, 1, n);
B_x = Box3D(I1_x, I2_x, I3_x);
x_points = B_x.Points();

I1_y = Interval(global_size, 2 * n + 1, 3 * n);
I2_y = Interval(global_size, 1, n);
I3_y = Interval(global_size, 1, n);
B_y = Box3D(I1_y, I2_y, I3_y);
y_points = B_y.Points();

k_fun = @(xx, yy) Gaussian(xx, yy, sqrt(3));

r_list = 1 : 8;
num_r = length(r_list);

A = k_fun(x_points, y_points);

[U_svd, S_svd, V_svd] = svd(A);

for it_r = 1 : num_r
    r = r_list(it_r);
    result = run_LR3D(A, U_svd, S_svd, V_svd, B_x, B_y, k_fun, r);

    file_name = "./data/WS_Gaussian/LR_" + string(r) + ".mat";
    save(file_name, "-struct", "result");
end

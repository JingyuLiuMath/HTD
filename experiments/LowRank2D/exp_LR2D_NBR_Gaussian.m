close all;
clear;
exp_LR2D_Settings;

I1_x = Interval(global_size, 1, n);
I2_x = Interval(global_size, 1, n);
B_x = Box2D(I1_x, I2_x);
x_points = B_x.Points();

I1_y = Interval(global_size, n + 1, 2 * n);
I2_y = Interval(global_size, 1, n);
B_y = Box2D(I1_y, I2_y);
y_points = B_y.Points();

k_fun = @(xx, yy) Gaussian(xx, yy, gaussian_sigma);

A = k_fun(x_points, y_points);

[U_svd, S_svd, V_svd] = svd(A);

for it_r = 1 : num_r
    r = r_list(it_r);
    result = run_LR2D(A, U_svd, S_svd, V_svd, B_x, B_y, k_fun, r);

    file_name = "./data/NBR_Gaussian/LR_" + string(r) + ".mat";
    save(file_name, "result");
end

%% Setting.
clear;
close all;

fprintf("H2DWQ HMultV\n");

n_list = [64, 128, 256, 512];
num_n = length(n_list);

rho_list = [2, 3, 4, 8];
num_rho = length(rho_list);

n_leaf = 16;
r = 8;
ad = "weak";
min_points = n_leaf^2;
%% Loop.
for i = 1 : num_n
    n_qu = n_list(i);
    fprintf("current n_qu: %d\n", n_qu);

    file_name = "./data/mmv/" + string(n_qu) + ".mat";
    load(file_name);

    for j = 1 : num_rho
        t_start = tic;

        rho = rho_list(j);
        n_uni = rho * n_qu;
        fprintf("current n_uni: %d\n", n_uni);

        file_name = "./data/intermatrix/" ...
            + string(n_qu) + "_" + string(rho) + ".mat";
        load(file_name);

        h_uni = 1 / n_uni;
        N_uni = n_uni^2;
        area_uni = h_uni^2;

        a_fun = @(xx) zeros(size(xx, 1), 1);
        k_fun = @(xx, yy) Gaussian(xx, yy, sqrt(2));

        I = Interval(n_uni);
        B = Box2D(I, I);
        T = ClusterTree2D(B);
        T.BuildTree(min_points);

        H = HTLR2D(B.I1_.size_, B.I2_.size_, B.I1_.size_, B.I2_.size_);
        H.Construct_IE(T, T, ad, a_fun, k_fun, r);

        f_uniFqu = uniFqu * u_qu;
        f_qu_approx = HMultV(H, reshape(f_uniFqu, [n_uni, n_uni]));
        f_qu_approx = quFuni * reshape(f_qu_approx, N_uni, 1);
        df_qu = f_qu_approx - f_qu;
        rel_err = norm(df_qu) / norm(f_qu);

        file_name = "./data/hmv/" ...
            + string(n_qu) + "_" + string(rho) + ".mat";
        save(file_name, "N_qu", "N_uni", "rel_err");
        spending_time = toc(t_start);
        fprintf("time on n_qu: %d, n_uni: %d, %e\n", n_qu, n_uni, spending_time);
        fprintf("rel_err: %e\n", rel_err);
        fprintf("\n\n");
    end
end

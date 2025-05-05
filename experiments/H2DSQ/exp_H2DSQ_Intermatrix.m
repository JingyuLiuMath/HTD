%% Setting.
close all;
rng(1);

fprintf("H2DSQ Intermatrix\n");

warning off;

n_list = [64, 128, 256, 512];
num_n = length(n_list);

rho_list = [2, 3, 4, 8];
num_rho = length(rho_list);

%% Loop.
for i = 1 : num_n
    n_qu = n_list(i);
    fprintf("current n_qu: %d\n", n_qu);

    file_name = "./data/problem/" + string(n_qu) + ".mat";
    load(file_name);

    for j = 1 : num_rho
        t_start = tic;

        rho = rho_list(j);
        n_uni = rho * n_qu;
        fprintf("current n_uni: %d\n", n_uni);

        h_uni = 1 / n_uni;
        N_uni = n_uni^2;
        area_uni = h_uni^2;

        I = Interval(n_uni);
        B = Box2D(I, I);

        T_uni = ClusterTree2D(B);
        T_uni.BuildTree(1);

        [uni_id, qu_id, val] = PolyIntersect(T_uni, qu_grid);
        uniFqu = sparse(uni_id, qu_id, val, N_uni, N_qu);
        uniFqu = uniFqu / area_uni;
        quFuni = sparse(qu_id, uni_id, val, N_qu, N_uni);
        quFuni = (1 ./ area_qu) .* quFuni;

        x_uni = B.Points();
        u_fun = @(x1, x2) 1 + 0.5 * exp(-(x1 - 0.3).^2 - (x2 - 0.6).^2) + sin(5 .* x1 .* x2);
        u_qu = u_fun(x_qu(:, 1), x_qu(:, 2));
        u_uni = u_fun(x_uni(:, 1), x_uni(:, 2));
        f_qu_approx = quFuni * u_uni;
        f_uni_approx = uniFqu * u_qu;
        df_real = f_qu_approx - u_qu;
        df_inter = f_uni_approx - u_uni;
        rel_err_quFuni = norm(df_real) / norm(u_qu);
        rel_err_uniFqu = norm(df_inter) / norm(u_uni);
        fprintf("rel_err of quFuni: %e\n", rel_err_quFuni);
        fprintf("rel_err of uniFqu: %e\n", rel_err_uniFqu);

        file_name = "./data/intermatrix/" ...
            + string(n_qu) + "_" + string(rho) + ".mat";
        save(file_name, ...
            "quFuni", "uniFqu", ...
            "n_qu", "n_uni", ...
            "N_qu", "N_uni", ...
            "rho", ...
            "rel_err_quFuni", "rel_err_uniFqu");
        spending_time = toc(t_start);
        fprintf("time on n_qu: %d, n_uni: %d, %e\n", n_qu, n_uni, spending_time);
        fprintf("\n\n");
    end
end

warning on;

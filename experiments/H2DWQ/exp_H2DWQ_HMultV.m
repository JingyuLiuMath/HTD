%% Setting.
clear;
close all;

fprintf("H2DWQ HMultV\n");

n_list = [64, 128, 256, 512];
num_n = length(n_list);

rho_list = [2, 3, 4];
num_rho = length(rho_list);

n_leaf = 16;
r = 8;
tol = 1e-10;
ad = "weak";
min_points = n_leaf^2;
%% Loop.
for i = 1 : num_n
    n_qu = n_list(i);
    fprintf("current n_qu: %d\n", n_qu);

    mmv_file = "./data/mmv/" + string(n_qu) + ".mat";
    mmv = load(mmv_file);

    for j = 1 : num_rho
        rho = rho_list(j);

        intermatrix_file = "./data/intermatrix/" ...
            + string(n_qu) + "_" + string(rho) + ".mat";
        intermatrix = load(intermatrix_file);

        result = run_H2QHMultV(...
            n_qu, rho, "Gaussian", ad, r, tol, min_points, mmv, intermatrix);

        file_name = "./data/hmv/" ...
            + string(n_qu) + "_" + string(rho) + ".mat";
        save(file_name, "-struct", "result");
    end
end

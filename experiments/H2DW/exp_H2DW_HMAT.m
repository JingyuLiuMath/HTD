close all;
clear;
rng(1);

exp_H2DW_Settings;

fprintf("H2DW HMAT\n");

for i = 1 : num_n
    n = n_list(i);

    problem_file = "./data/problem/" + string(n) + ".mat";
    load(problem_file);

    result = run_HMAT(...
        n, dim, kernel, ad, r, tol, min_points, result, ntest);

    file_name = "./data/hmat/" + string(n) + "_r_" + string(r) + ".mat";
    save(file_name, "result", '-v7.3');
end

close all;
clear;
rng(1);

exp_H3DW_Settings;

fprintf("H3DW HMAT\n");

for i = 1 : num_n
    n = n_list(i);

    problem_file = "./data/problem/" + string(n) + ".mat";
    load(problem_file);

    result = run_HMAT(...
        n, dim, kernel, ad, r, tol, min_points, result, ntest);

    file_name = "./data/hmat/" + string(n) + "_r_" + string(r) + ".mat";
    save(file_name, "result", '-v7.3');
end

close all;
clear;
rng(1);

exp_H2DS_Settings;

fprintf("H2DS HTLR\n");

for i = 1 : num_n
    n = n_list(i);

    problem_file = "./data/problem/" + string(n) + ".mat";
    load(problem_file);

    result = run_HTLR(...
        n, dim, kernel, ad, r, tol, min_points, result, ntest);

    file_name = "./data/htlr/" + string(n) + "_r_" + string(r) + ".mat";
    save(file_name, "result", '-v7.3');
end

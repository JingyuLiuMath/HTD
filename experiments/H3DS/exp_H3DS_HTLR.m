close all;
clear;
rng(1);

exp_H3DS_Settings;

fprintf("H3DS HTLR\n");

for i = 1 : num_n
    n = n_list(i);

    problem_file = "./data/problem/" + string(n) + ".mat";
    problem_data = load(problem_file);
    if isfield(problem_data, "result")
        problem = problem_data.result;
    else
        problem = problem_data;
    end

    result = run_HTLR(...
        n, dim, kernel, kappa, ...
        ad, r, tol, min_points, problem, ntest);

    file_name = "./data/htlr/" + string(n) + "_r_" + string(r) + ".mat";
    save(file_name, "result", '-v7.3');
end

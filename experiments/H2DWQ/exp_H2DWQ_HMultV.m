clear;
close all;
rng(1);

exp_H2DWQ_Settings;

fprintf("H2DWQ HMultV\n");

for i = 1 : num_n
    n_qu = n_list(i);
    fprintf("current n_qu: %d\n", n_qu);

    problem_file = "./data/problem/" + string(n_qu) + ".mat";
    problem_data = load(problem_file);
    if isfield(problem_data, "result")
        problem = problem_data.result;
    else
        problem = problem_data;
    end

    for j = 1 : num_rho
        rho = rho_list(j);

        intermatrix_file = "./data/intermatrix/" ...
            + string(n_qu) + "_" + string(rho) + ".mat";
        intermatrix_data = load(intermatrix_file);
        if isfield(intermatrix_data, "result")
            intermatrix = intermatrix_data.result;
        else
            intermatrix = intermatrix_data;
        end

        result = run_HQHMultV(...
            n_qu, rho, kernel, kappa, ad, r, tol, min_points, ...
            problem, intermatrix, ntest);

        file_name = "./data/hmv/" ...
            + string(n_qu) + "_" + string(rho) + ".mat";
        save(file_name, "result", "-v7.3");
    end
end

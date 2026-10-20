clear;
close all;
rng(1);

exp_H2DWQ_Settings;

fprintf("H2DWQ Intermatrix\n");

warning off;

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
        result = run_HQIntermatrix(n_qu, rho, problem);

        file_name = "./data/intermatrix/" ...
            + string(n_qu) + "_" + string(rho) + ".mat";
        save(file_name, "result", "-v7.3");
    end
end

warning on;

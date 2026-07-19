%% Setting.
close all;
rng(1);

fprintf("H2DSQ Intermatrix\n");

warning off;

n_list = [64, 128, 256, 512];
num_n = length(n_list);

rho_list = [2, 3, 4];
num_rho = length(rho_list);

%% Loop.
for i = 1 : num_n
    n_qu = n_list(i);
    fprintf("current n_qu: %d\n", n_qu);

    problem_file = "./data/problem/" + string(n_qu) + ".mat";
    problem = load(problem_file);

    for j = 1 : num_rho
        rho = rho_list(j);
        result = run_H2QIntermatrix(n_qu, rho, problem);

        file_name = "./data/intermatrix/" ...
            + string(n_qu) + "_" + string(rho) + ".mat";
        save(file_name, "-struct", "result");
    end
end

warning on;

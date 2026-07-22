close all;
clear;
rng(1);

exp_H2DWQ_Settings;

fprintf("H2DWQ Problem\n");

for i = 1 : num_n
    n_qu = n_list(i);
    result = run_HQProblem(...
        n_qu, kernel, kappa, block_size, nsample);

    file_name = "./data/problem/" + string(n_qu) + ".mat";
    save(file_name, "result", "-v7.3");
end

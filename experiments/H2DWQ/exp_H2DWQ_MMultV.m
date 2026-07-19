%% Setting.
clear;
close all;

fprintf("H2DWQ MMV\n");

n_list = [64, 128, 256, 512];
num_n = length(n_list);

block_size = 65536;
%% Loop.
for i = 1 : num_n
    n_qu = n_list(i);

    problem_file = "./data/problem/" + string(n_qu) + ".mat";
    problem = load(problem_file);

    result = run_H2QMMultV(n_qu, "Gaussian", block_size, problem);

    file_name = "./data/mmv/" + string(n_qu) + ".mat";
    save(file_name, "-struct", "result");
end

%% Setting.
clear;
close all;

fprintf("H2DSQ MMV\n");

n_list = [256, 512];
num_n = length(n_list);

block_size = 65536;
%% Loop.
for i = 1 : num_n
    n_qu = n_list(i);

    problem_file = "./data/problem/" + string(n_qu) + ".mat";
    problem = load(problem_file);

    result = run_H2QMMultV(n_qu, "SLP", block_size, problem);

    file_name = "./data/mmv/" + string(n_qu) + ".mat";
    save(file_name, "-struct", "result");
end

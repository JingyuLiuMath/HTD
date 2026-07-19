close all;
clear;
rng(1);

fprintf("H2DWQ Problem\n");

n_list = [64, 128, 256, 512];
num_n = length(n_list);

for i = 1 : num_n
    n_qu = n_list(i);
    result = run_H2QProblem(n_qu);

    file_name = "./data/problem/" + string(n_qu) + ".mat";
    save(file_name, "-struct", "result");
end

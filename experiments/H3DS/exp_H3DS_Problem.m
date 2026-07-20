close all;
clear;
rng(1);

exp_H3DS_Settings;

fprintf("H3DS Problem\n");

for i = 1 : num_n
    n = n_list(i);
    result = run_HProblem(...
        n, dim, kernel, kappa, nsample, n_sample_threshold, num_rhs);

    file_name = "./data/problem/" + string(n) + ".mat";
    save(file_name, "result", '-v7.3');
end

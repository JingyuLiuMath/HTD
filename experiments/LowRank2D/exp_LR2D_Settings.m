close all;
clear;
rng_seed = 1;
rng(rng_seed);

fprintf("LR2D Settings\n");

global_size = 128;
n = 32;
kappa = 8;

r_list = 1 : 16;
num_r = length(r_list);

fprintf("rng_seed: %d\n", rng_seed);
fprintf("global_size: %d\n", global_size);
fprintf("n: %d\n", n);
fprintf("kappa: %.1e\n", kappa);
fprintf("r_list: %s\n", mat2str(r_list));
fprintf("num_r: %d\n\n", num_r);

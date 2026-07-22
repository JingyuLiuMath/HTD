close all;
clear;
rng_seed = 1;
rng(rng_seed);

fprintf("LR3D Settings\n");

global_size = 64;
n = 16;
kappa = 8;
gaussian_sigma = sqrt(3);
slp_sval = 0;
helm_sval = 0;

r_list = 1 : 8;
num_r = length(r_list);

fprintf("rng_seed: %d\n", rng_seed);
fprintf("global_size: %d\n", global_size);
fprintf("n: %d\n", n);
fprintf("kappa: %.1e\n", kappa);
fprintf("gaussian_sigma: %.1e\n", gaussian_sigma);
fprintf("slp_sval: %.1e\n", slp_sval);
fprintf("helm_sval: %.1e\n", helm_sval);
fprintf("r_list: %s\n", mat2str(r_list));
fprintf("num_r: %d\n\n", num_r);

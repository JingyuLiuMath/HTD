close all;
clear;
rng_seed = 1;
rng(rng_seed);

fprintf("H3DS Settings\n");

if ispc
    n_list = [8, 16, 32];
    nsample = 100;

    n_leaf = 4;
    r = 4;
elseif isunix
    n_list = [32, 64, 128, 256];
    nsample = 256;

    n_leaf = 4;
    r = 4;
end
num_n = length(n_list);
n_sample_threshold = n_list(1) / 2;

dim = 3;
kernel = "SLP";
kappa = 0;
num_rhs = 10;
min_points = n_leaf^3;
ad = "strong";
tol = 1e-3;

ntest = 3;

fprintf("rng_seed: %d\n", rng_seed);
fprintf("n_list: %s\n", mat2str(n_list));
fprintf("num_n: %d\n", num_n);
fprintf("dim: %d\n", dim);
fprintf("kernel: %s\n", kernel);
fprintf("kappa: %.1e\n", kappa);
fprintf("nsample: %d\n", nsample);
fprintf("n_sample_threshold: %d\n", n_sample_threshold);
fprintf("num_rhs: %d\n", num_rhs);
fprintf("n_leaf: %d\n", n_leaf);
fprintf("min_points: %d\n", min_points);
fprintf("ad: %s\n", ad);
fprintf("r: %d\n", r);
fprintf("tol: %.1e\n", tol);
fprintf("ntest: %d\n\n", ntest);

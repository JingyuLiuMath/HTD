close all;
clear;
rng_seed = 1;
rng(rng_seed);

fprintf("H2DWQ Settings\n");

if ispc
    n_list = [16, 32];
    nsample = 100;
elseif isunix
    n_list = [64, 128, 256, 512];
    nsample = 256;
end
num_n = length(n_list);

rho_list = [2, 3, 4];
num_rho = length(rho_list);

kernel = "Gaussian";
kappa = 0;
block_size = 65536;
n_leaf = 16;
r = 8;
tol = 1e-10;
ad = "weak";
min_points = n_leaf^2;
ntest = 3;

fprintf("rng_seed: %d\n", rng_seed);
fprintf("n_list: %s\n", mat2str(n_list));
fprintf("num_n: %d\n", num_n);
fprintf("rho_list: %s\n", mat2str(rho_list));
fprintf("num_rho: %d\n", num_rho);
fprintf("kernel: %s\n", kernel);
fprintf("kappa: %.1e\n", kappa);
fprintf("nsample: %d\n", nsample);
fprintf("block_size: %d\n", block_size);
fprintf("n_leaf: %d\n", n_leaf);
fprintf("min_points: %d\n", min_points);
fprintf("ad: %s\n", ad);
fprintf("r: %d\n", r);
fprintf("tol: %.1e\n", tol);
fprintf("ntest: %d\n\n", ntest);

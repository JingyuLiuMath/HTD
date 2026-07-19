close all;
clear;
rng(1);

fprintf("H2DW Settings\n");

if ispc
    n_list = [32, 64, 128];
    nsample = 100;
    n_sample_threshold = 64;

    n_leaf = 8;
    r = 4;
elseif isunix
    n_list = [256, 512, 1024, 2048, 4096, 8192];
    nsample = 256;
    n_sample_threshold = 512;

    n_leaf = 16;
    r = 8;
end
num_n = length(n_list);

dim = 2;
kernel = "Gaussian";
num_rhs = 30;
min_points = n_leaf^2;
ad = "weak";
tol = 1e-3;

ntest = 3;

close all;
clear;
rng(1);

fprintf("H3DW Settings\n");

if ispc
    n_list = [8, 16, 32];
    nsample = 100;
    n_sample_threshold = 16;

    n_leaf = 4;
    r = 4;
elseif isunix
    n_list = [32, 64, 128, 256, 512];
    nsample = 256;
    n_sample_threshold = 128;

    n_leaf = 4;
    r = 4;
end
num_n = length(n_list);

dim = 3;
kernel = "Gaussian";
num_rhs = 30;
min_points = n_leaf^3;
ad = "weak";
tol = 1e-3;

ntest = 3;

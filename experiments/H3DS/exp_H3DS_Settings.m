close all;
clear;
rng(1);

fprintf("H3DS Settings\n");

if ispc
    n_list = [8, 16, 32];
    nsample = 100;
    n_sample_threshold = 16;

    n_leaf = 4;
    r = 4;
elseif isunix
    n_list = [32, 64, 128, 256];
    nsample = 256;
    n_sample_threshold = 64;

    n_leaf = 4;
    r = 4;
end
num_n = length(n_list);

dim = 3;
kernel = "SLP";
kappa = 0;
num_rhs = 30;
min_points = n_leaf^3;
ad = "strong";
tol = 1e-3;

ntest = 3;

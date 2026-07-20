close all;
clear;
rng(1);

fprintf("H2DS Settings\n");

if ispc
    n_list = [32, 64, 128];
    nsample = 100;
    n_sample_threshold = 64;

    n_leaf = 8;
    r = 10;
elseif isunix
    n_list = [256, 512, 1024, 2048, 4096];
    nsample = 256;
    n_sample_threshold = 512;

    n_leaf = 16;
    r = 8;
end
num_n = length(n_list);

dim = 2;
kernel = "Helm";
kappa = 10;
num_rhs = 30;
min_points = n_leaf^2;
ad = "strong";
tol = 1e-3;

ntest = 3;

close all;
clear;
rng(1);

fprintf("H3DW HTLR\n");

n_list = [32, 64, 128, 256, 512];
num_n = length(n_list);

n_leaf = 5;
min_points = n_leaf^3;
r = 4;
ad = "weak";

for i = 1 : num_n
    n = n_list(i);
    fprintf("current n: %d\n", n);

    N = n^3;
    h = 1 / n;

    a_fun = @(xx) zeros(size(xx, 1), 1);
    k_fun = @(xx, yy) Gaussian(xx, yy, sqrt(3));

    I = Interval(n);
    B = Box3D(I, I, I);

    T = ClusterTree3D(B);
    T.BuildTree(min_points);

    H = HTLR3D(B.I1_.size_, B.I2_.size_, B.I3_.size_, B.I1_.size_, B.I2_.size_, B.I3_.size_);
    construct_time = tic;
    H.Construct_IE(T, T, ad, a_fun, k_fun, r);
    construct_time = toc(construct_time);
    fprintf("construct time: %e\n", construct_time);

    hmat_mem = H.Storage();

    file_name = "./data/problem/" + string(n) + ".mat";
    load(file_name);

    u_ten = reshape(u_ex, [n, n, n]);
    f_ten = H.HMultV(u_ten);
    f_ten = H.HMultV(u_ten);
    hmultv_time = tic;
    f_ten = H.HMultV(u_ten);
    hmultv_time = toc(hmultv_time);
    f = reshape(f_ten, N, 1);
    fprintf("hmultv_time: %e\n", hmultv_time);

    if is_sampled
        err = 0;
        f = f(rand_rind);
        rand_err = norm(f - f_ex) / norm(f_ex);
    else
        err = norm(f - f_ex) / norm(f_ex);
        f = f(rand_rind);
        f_ex = f_ex(rand_rind);
        rand_err = norm(f - f_ex) / norm(f_ex);
    end
    fprintf("err: %e, rand_err: %e\n", err, rand_err);
    fprintf("\n\n");

    file_name = "./data/htlr/" + string(n) + "_r_" + string(r) + ".mat";
    save(file_name, ...
        "construct_time", "hmat_mem", "hmultv_time", ...
        "err", "rand_err");
end

close all;
clear;
rng(1);

fprintf("H3DS HTLR\n");

n_list = [32, 64, 128, 160, 256];
num_n = length(n_list);

n_leaf = 4;
min_points = n_leaf^3;
r = 4;
ad = "strong";

for i = 1 : num_n
    n = n_list(i);
    disp("current n: " + n)

    N = n^3;
    h = 1 / n;

    a_fun = @(xx) zeros(size(xx, 1), 1);
    s_fun = @(xx1, xx2, xx3) 1 ./ sqrt((xx1.^2 + xx2.^2 + xx3.^2)) / (4 * pi);
    sval = 0;
    sval = sval + integral3(s_fun, ...
        -h / 2, 0, ...
        -h / 2, 0, ...
        -h / 2, 0);
    sval = sval + integral3(s_fun, ...
        0, h / 2, ...
        -h / 2, 0, ...
        -h / 2, 0);
    sval = sval + integral3(s_fun, ...
        -h / 2, 0, ...
        0, h / 2, ...
        -h / 2, 0);
    sval = sval + integral3(s_fun, ...
        0, h / 2, ...
        0, h / 2, ...
        -h / 2, 0);
    sval = sval + integral3(s_fun, ...
        -h / 2, 0, ...
        -h / 2, 0, ...
        0, h / 2);
    sval = sval + integral3(s_fun, ...
        0, h / 2, ...
        -h / 2, 0, ...
        0, h / 2);
    sval = sval + integral3(s_fun, ...
        -h / 2, 0, ...
        0, h / 2, ...
        0, h / 2);
    sval = sval + integral3(s_fun, ...
        0, h / 2, ...
        0, h / 2, ...
        0, h / 2);
    sval = sval / h^3;
    k_fun = @(xx, yy) SLP3D(xx, yy, sval);

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

close all;
clear;
rng(1);

fprintf("H2DW HMAT\n");

n_list = [256, 512, 1024, 2048, 4096, 8192];
num_n = length(n_list);

n_leaf = 16;
min_points = n_leaf^2;
r = 8;
ad = "weak";

for i = 1 : num_n
    n = n_list(i);
    disp("current n: " + n)

    N = n^2;
    h = 1 / n;

    a_fun = @(xx) zeros(size(xx, 1), 1);
    k_fun = @(xx, yy) Gaussian(xx, yy, sqrt(2));

    I = Interval(n);
    B = Box2D(I, I);

    T = ClusterTree2D(B);
    T.BuildTree(min_points);
    p = T.p_;
    q = T.q_;

    H = HMAT2D(B.size_, B.size_);
    construct_time = tic;
    H.Construct_IE(T, T, ad, a_fun, k_fun, r);
    construct_time = toc(construct_time);
    fprintf("construct time: %e\n", construct_time);

    hmat_mem = H.Storage();

    file_name = "./data/problem/" + string(n) + ".mat";
    load(file_name);

    u = u_ex(q, :);
    hmultv_time = tic;
    f = H.HMultV(u);
    hmultv_time = toc(hmultv_time);
    f = f(p, :);
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

    file_name = "./data/hmat/" + string(n) + "_r_" + string(r) + ".mat";
    save(file_name, ...
        "construct_time", "hmat_mem", "hmultv_time", ...
        "err", "rand_err");
end

function result = run_HMAT(...
        n, dim, kernel_type, kappa, ...
        ad, r, tol, min_points, problem, ntest)
% run_HMAT constructs and applies an HMAT approximation for one size.

arguments (Input)
    n (1, 1) double;
    dim (1, 1) double;
    kernel_type (1, 1) string;
    kappa (1, 1) double;
    ad (1, 1) string;
    r (1, 1) double;
    tol (1, 1) double;
    min_points (1, 1) double;
    problem struct;
    ntest (1, 1) double;
end

arguments (Output)
    result struct;
end

fprintf("current n: %d\n", n);

[a_fun, k_fun] = ExperimentKernel(n, dim, kernel_type, kappa);
B = ExperimentBox(n, dim);

if dim == 2
    T = ClusterTree2D(B);
    H = HMAT2D(B.size_, B.size_);
elseif dim == 3
    T = ClusterTree3D(B);
    H = HMAT3D(B.size_, B.size_);
else
    error("run_HMAT:UnsupportedDimension", "dim must be 2 or 3.");
end

T.BuildTree(min_points);
p = T.p_;
q = T.q_;

construct_time = tic;
H.Construct_IE(T, T, ad, a_fun, k_fun, r, tol);
construct_time = toc(construct_time);
fprintf("construct time: %.1e\n", construct_time);

hmat_mem = byte_to_gb(H.Storage());
fprintf("hmat_mem: %.1e\n", hmat_mem);

u = problem.u_ex(q, :);
% Warm up the recursive matrix-vector product before measuring it.  This
% excludes one-time JIT compilation and function-loading overhead.
f = H.HMultV(u);
hmultv_time_start = tic;
for it = 1 : ntest
    f = H.HMultV(u);
end
hmultv_time = toc(hmultv_time_start) / ntest;
f = f(p, :);
fprintf("hmultv_time: %.1e\n", hmultv_time);

[err, rand_err] = HExperimentError(f, ...
    problem.f_ex, ...
    problem.f_ex_sampled, problem.rand_rind);
fprintf("err: %.1e, rand_err: %.1e\n", err, rand_err);
fprintf("\n\n");

result.construct_time = construct_time;
result.hmat_mem = hmat_mem;
result.hmultv_time = hmultv_time;
result.err = err;
result.rand_err = rand_err;

end

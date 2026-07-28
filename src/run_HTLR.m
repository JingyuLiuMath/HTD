function result = run_HTLR(...
        n, dim, kernel_type, kappa, ...
        ad, r, tol, min_points, problem, ntest)
% run_HTLR constructs and applies an HTLR approximation for one size.

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

N = n^dim;
[a_fun, k_fun] = ExperimentKernel(n, dim, kernel_type, kappa);
B = ExperimentBox(n, dim);

if dim == 2
    T = ClusterTree2D(B);
    H = HTLR2D(B.I1_.size_, B.I2_.size_, B.I1_.size_, B.I2_.size_);
elseif dim == 3
    T = ClusterTree3D(B);
    H = HTLR3D(...
        B.I1_.size_, B.I2_.size_, B.I3_.size_, ...
        B.I1_.size_, B.I2_.size_, B.I3_.size_);
else
    error("run_HTLR:UnsupportedDimension", "dim must be 2 or 3.");
end

T.BuildTree(min_points);

construct_time = tic;
H.Construct_IE(T, T, ad, a_fun, k_fun, r, tol);
construct_time = toc(construct_time);
fprintf("construct time: %.1e\n", construct_time);

hmat_mem = byte_to_gb(H.Storage());
fprintf("hmat_mem: %.1e\n", hmat_mem);

tensor_size = [n * ones(1, dim), problem.num_rhs];
u_ten = reshape(problem.u_ex, tensor_size);
% Warm up the recursive tensor matrix-vector product before measuring it.
% This makes its timing directly comparable with the HMAT timing.
f_ten = H.HMultV(u_ten);
hmultv_time_start = tic;
for it = 1 : ntest
    f_ten = H.HMultV(u_ten);
end
hmultv_time = toc(hmultv_time_start) / ntest;
f = reshape(f_ten, N, problem.num_rhs);
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

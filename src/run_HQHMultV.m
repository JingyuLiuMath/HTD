function result = run_HQHMultV(...
    n_qu, rho, kernel_type, kappa, ad, r, tol, min_points, ...
    problem, intermatrix, ntest)
% run_HQHMultV applies one HTLR quadrature approximation.

arguments (Input)
    n_qu (1, 1) double;
    rho (1, 1) double;
    kernel_type (1, 1) string;
    kappa (1, 1) double;
    ad (1, 1) string;
    r (1, 1) double;
    tol (1, 1) double;
    min_points (1, 1) double;
    problem struct;
    intermatrix struct;
    ntest (1, 1) double;
end

arguments (Output)
    result struct;
end

n_uni = rho * n_qu;
fprintf("current n_uni: %d\n", n_uni);
fprintf("rel_err of quFuni: %.1e\n", intermatrix.rel_err_quFuni);
fprintf("rel_err of uniFqu: %.1e\n", intermatrix.rel_err_uniFqu);

N_qu = intermatrix.N_qu;
N_uni = n_uni^2;
if isfield(problem, "rand_rind")
    rand_rind = problem.rand_rind;
    f_qu_reference = problem.f_qu_sampled;
else
    rand_rind = (1 : N_qu).';
    f_qu_reference = problem.f_qu;
end
nsample = length(rand_rind);

[a_fun, k_fun] = ExperimentKernel(n_uni, 2, kernel_type, kappa);

I = Interval(n_uni);
B = Box2D(I, I);
T = ClusterTree2D(B);
T.BuildTree(min_points);

H = HTLR2D(B.I1_.size_, B.I2_.size_, B.I1_.size_, B.I2_.size_);
construct_time_start = tic;
H.Construct_IE(T, T, ad, a_fun, k_fun, r, tol);
construct_time = toc(construct_time_start);
fprintf("construct time: %.1e\n", construct_time);

qu_to_uni_time_start = tic;
for it = 1 : ntest
    f_uniFqu = intermatrix.uniFqu * problem.u_qu;
end
qu_to_uni_time = toc(qu_to_uni_time_start) / ntest;

f_uniFqu = reshape(f_uniFqu, [n_uni, n_uni]);
hmultv_time_start = tic;
for it = 1 : ntest
    f_uni = H.HMultV(f_uniFqu);
end
hmultv_time = toc(hmultv_time_start) / ntest;

f_uni = reshape(f_uni, N_uni, 1);
uni_to_qu_time_start = tic;
for it = 1 : ntest
    f_qu_approx = intermatrix.quFuni(rand_rind, :) * f_uni;
end
uni_to_qu_time = toc(uni_to_qu_time_start) / ntest;

apply_time = qu_to_uni_time + hmultv_time + uni_to_qu_time;
fprintf("qu-to-uni time: %.1e\n", qu_to_uni_time);
fprintf("hmultv time: %.1e\n", hmultv_time);
fprintf("sampled uni-to-qu time: %.1e\n", uni_to_qu_time);
fprintf("sampled-output apply time: %.1e\n", apply_time);

df_qu = f_qu_approx - f_qu_reference;
rand_err = norm(df_qu) / norm(f_qu_reference);
rel_err = rand_err;

fprintf("random sampled error: %.1e\n", rand_err);
fprintf("\n\n");

result.N_qu = N_qu;
result.N_uni = N_uni;
result.nsample = nsample;
result.rand_rind = rand_rind;
result.construct_time = construct_time;
result.qu_to_uni_time = qu_to_uni_time;
result.hmultv_time = hmultv_time;
result.uni_to_qu_time = uni_to_qu_time;
result.apply_time = apply_time;
result.rel_err = rel_err;
result.rand_err = rand_err;

end

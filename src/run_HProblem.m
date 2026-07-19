function result = run_HProblem(n, dim, kernel_type, nsample, n_sample_threshold, num_rhs)
% run_HProblem forms the sampled reference vector for one problem size.

arguments (Input)
    n (1, 1) double;
    dim (1, 1) double;
    kernel_type (1, 1) string;
    nsample (1, 1) double;
    n_sample_threshold (1, 1) double
    num_rhs (1, 1) double
end

arguments (Output)
    result struct;
end

fprintf("current n: %d\n", n);

N = n^dim;
[a_fun, k_fun] = ExperimentKernel(n, dim, kernel_type);

B = ExperimentBox(n, dim);
x = B.Points();

u_ex = randn(N, num_rhs);
nsample = min(nsample, N);
rand_rind = randperm(N, nsample);

if n <= n_sample_threshold
    f_ex = a_fun(x) .* u_ex + k_fun(x, x) / N * u_ex;
else
    f_ex = [];
end
f_ex_sampled = a_fun(x(rand_rind, :)) .* u_ex(rand_rind, :) ...
    + k_fun(x(rand_rind, :), x) / N * u_ex;

result.u_ex = u_ex;
result.f_ex = f_ex;
result.f_ex_sampled = f_ex_sampled;
result.rand_rind = rand_rind;
result.num_rhs = num_rhs;

end

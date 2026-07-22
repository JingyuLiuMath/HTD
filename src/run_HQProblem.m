function result = run_HQProblem(...
        n_qu, kernel_type, kappa, block_size, nsample)
% run_HQProblem builds one quasi-uniform problem and sampled reference.

arguments (Input)
    n_qu (1, 1) double;
    kernel_type (1, 1) string;
    kappa (1, 1) double;
    block_size (1, 1) double;
    nsample (1, 1) double;
end

arguments (Output)
    result struct;
end

fprintf("current n: %d\n", n_qu);

problem_time_start = tic;
[N_qu, qu_grid, x_qu, v1, v2, v3] = TriangularQUGrid2D(n_qu);
area_qu = qu_grid.area;
problem_time = toc(problem_time_start);
fprintf("problem time: %.1e\n", problem_time);

mmultv_time_start = tic;

nsample = min(nsample, N_qu);
rand_rind = randperm(N_qu, nsample).';
x_qu_sampled = x_qu(rand_rind, :);

u_fun = @(x1, x2) 1 + 0.5 * exp(...
    -(x1 - 0.3).^2 - (x2 - 0.6).^2 + sin(5 .* x1 .* x2));
u_qu = u_fun(x_qu(:, 1), x_qu(:, 2));

[a_fun, k_fun] = ExperimentKernel(n_qu, 2, kernel_type, kappa);
f_qu_sampled = a_fun(x_qu_sampled) .* u_qu(rand_rind, :);

is_singular = kernel_type == "SLP" || kernel_type == "Helm";
if is_singular
    diag_qu_sampled = zeros(nsample, 1);
    for j = 1 : nsample
        rind = rand_rind(j);
        if kernel_type == "SLP"
            diag_qu_sampled(j) = SLP2DTriangleSelfValue(...
                x_qu(rind, :), v1(rind, :), v2(rind, :), v3(rind, :));
        else
            diag_qu_sampled(j) = Helm2DTriangleSelfValue(...
                x_qu(rind, :), v1(rind, :), v2(rind, :), v3(rind, :), ...
                kappa);
        end
    end
end

num_block = ceil(N_qu / block_size);
coff = 0;
for cit = 1 : num_block
    cind = (coff + 1) : min(coff + block_size, N_qu);
    tmp_mat = k_fun(x_qu_sampled, x_qu(cind, :)) .* area_qu(cind).';
    if is_singular
        [has_diag, diag_col] = ismember(rand_rind, cind);
        diag_row = find(has_diag);
        diag_ind = sub2ind(size(tmp_mat), diag_row, diag_col(has_diag));
        tmp_mat(diag_ind) = diag_qu_sampled(has_diag);
    end
    f_qu_sampled = f_qu_sampled + tmp_mat * u_qu(cind, :);
    coff = coff + block_size;
end

mmultv_time = toc(mmultv_time_start);
fprintf("mmultv time: %.1e\n", mmultv_time);
fprintf("\n");

result.N_qu = N_qu;
result.qu_grid = qu_grid;
result.x_qu = x_qu;
result.v1 = v1;
result.v2 = v2;
result.v3 = v3;
result.area_qu = area_qu;
result.problem_time = problem_time;
result.u_fun = u_fun;
result.u_qu = u_qu;
result.f_qu_sampled = f_qu_sampled;
result.rand_rind = rand_rind;
result.nsample = nsample;
result.mmultv_time = mmultv_time;

end

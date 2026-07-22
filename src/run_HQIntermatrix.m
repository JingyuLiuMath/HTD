function result = run_HQIntermatrix(n_qu, rho, problem)
% run_HQIntermatrix builds quadrature-uniform transfer matrices.

arguments (Input)
    n_qu (1, 1) double;
    rho (1, 1) double;
    problem struct;
end

arguments (Output)
    result struct;
end

fprintf("current n_uni: %d\n", rho * n_qu);

N_qu = problem.N_qu;
qu_grid = problem.qu_grid;
x_qu = problem.x_qu;
area_qu = problem.area_qu;

n_uni = rho * n_qu;
h_uni = 1 / n_uni;
N_uni = n_uni^2;
area_uni = h_uni^2;

I = Interval(n_uni);
B = Box2D(I, I);

T_uni = ClusterTree2D(B);
T_uni.BuildTree(1);

intermatrix_time_start = tic;
[uni_id, qu_id, val] = PolyIntersect(T_uni, qu_grid);
uniFqu = sparse(uni_id, qu_id, val, N_uni, N_qu);
uniFqu = uniFqu / area_uni;
quFuni = sparse(qu_id, uni_id, val, N_qu, N_uni);
quFuni = (1 ./ area_qu) .* quFuni;
intermatrix_time = toc(intermatrix_time_start);

x_uni = B.Points();
u_fun = @(x1, x2) 1 + 0.5 * exp(...
    -(x1 - 0.3).^2 - (x2 - 0.6).^2) + sin(5 .* x1 .* x2);
u_qu = u_fun(x_qu(:, 1), x_qu(:, 2));
u_uni = u_fun(x_uni(:, 1), x_uni(:, 2));
f_qu_approx = quFuni * u_uni;
f_uni_approx = uniFqu * u_qu;
df_real = f_qu_approx - u_qu;
df_inter = f_uni_approx - u_uni;
rel_err_quFuni = norm(df_real) / norm(u_qu);
rel_err_uniFqu = norm(df_inter) / norm(u_uni);
fprintf("rel_err of quFuni: %.1e\n", rel_err_quFuni);
fprintf("rel_err of uniFqu: %.1e\n", rel_err_uniFqu);

fprintf("intermatrix time: %.1e\n", intermatrix_time);
fprintf("\n\n");

result.quFuni = quFuni;
result.uniFqu = uniFqu;
result.n_qu = n_qu;
result.n_uni = n_uni;
result.N_qu = N_qu;
result.N_uni = N_uni;
result.rho = rho;
result.rel_err_quFuni = rel_err_quFuni;
result.rel_err_uniFqu = rel_err_uniFqu;
result.intermatrix_time = intermatrix_time;

end

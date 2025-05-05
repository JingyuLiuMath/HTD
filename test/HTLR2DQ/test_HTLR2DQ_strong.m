clear;
close all;
rng(1);
warning off;

% *************************************************************************
% Settings.
n_qu = 32;
rho = 2;
n_leaf = 16;
r = 8;
ad = "strong";
% -------------------------------------------------------------------------


% *************************************************************************
% Basic.
n_uni = rho * n_qu;
h_uni = 1 / n_uni;
N_uni = n_uni^2;
area_uni = h_uni^2;

a_fun = @(xx) zeros(size(xx, 1), 1);
s_fun = @(xx1, xx2) -reallog(sqrt(xx1.^2 + xx2.^2)) / (2 * pi);
sval = integral2(s_fun, ...
    -h_uni / 2, h_uni / 2, ...
    -h_uni / 2, h_uni / 2) / area_uni;
k_fun = @(xx, yy) SLP2D(xx, yy, sval);

min_points = n_leaf^2;
% -------------------------------------------------------------------------


% *************************************************************************
% Preliminary.
[N_qu, qu_grid, x_qu, v1, v2, v3] = TriangularQUGrid2D(n_qu);
area_qu = qu_grid.area;

L_qu = k_fun(x_qu, x_qu);
L_qu = L_qu .* area_qu.';
diag_L_qu = zeros(N_qu, 1);
for j = 1 : N_qu
    Lj_fun = @(y1, y2) -log(sqrt(...
        (x_qu(j, 1) - y1).^2 + (x_qu(j, 2) - y2).^2)) / (2 * pi);
    diag_L_qu(j) = TriangularIntegral(Lj_fun, v1(j, :), v2(j, :), v3(j, :));
end
L_qu = tril(L_qu, -1) + triu(L_qu, 1) + diag(diag_L_qu);
A_qu = diag(a_fun(x_qu)) + L_qu;
% -------------------------------------------------------------------------


% *************************************************************************
% HTLR.
I = Interval(n_uni);
B = Box2D(I, I);
T = ClusterTree2D(B);
T.BuildTree(min_points);

H = HTLR2D(B.I1_.size_, B.I2_.size_, B.I1_.size_, B.I2_.size_);
H.Construct_IE(T, T, ad, a_fun, k_fun, r);
% -------------------------------------------------------------------------


% *************************************************************************
% Interpolation.
T_uni = ClusterTree2D(B);
T_uni.BuildTree(1);

[uni_id, qu_id, val] = PolyIntersect(T_uni, qu_grid);
uniFqu = sparse(uni_id, qu_id, val, N_uni, N_qu);
uniFqu = uniFqu / area_uni;
quFuni = sparse(qu_id, uni_id, val, N_qu, N_uni);
quFuni = (1 ./ area_qu) .* quFuni;

x_uni = B.Points();
u_fun = @(x1, x2) 1 + 0.5 * exp(-(x1 - 0.3).^2 - (x2 - 0.6).^2) + sin(5 .* x1 .* x2);
u_qu = u_fun(x_qu(:, 1), x_qu(:, 2));
u_uni = u_fun(x_uni(:, 1), x_uni(:, 2));
f_qu_approx = quFuni * u_uni;
f_uni_approx = uniFqu * u_qu;
df_real = f_qu_approx - u_qu;
df_inter = f_uni_approx - u_uni;
rel_err_quFuni = norm(df_real) / norm(u_qu);
rel_err_uniFqu = norm(df_inter) / norm(u_uni);
fprintf("rel_err of quFuni: %e\n", rel_err_quFuni);
fprintf("rel_err of uniFqu: %e\n", rel_err_uniFqu);
% -------------------------------------------------------------------------


% *************************************************************************
% HMultV
u_fun = @(x1, x2) 1 + 0.5 * exp(-(x1 - 0.3).^2 - (x2 - 0.6).^2) + sin(5 .* x1 .* x2);
u_qu = u_fun(x_qu(:, 1), x_qu(:, 2));

f_qu = A_qu * u_qu;

f_uniFqu = uniFqu * u_qu;
f_qu_approx = HMultV(H, reshape(f_uniFqu, [n_uni, n_uni]));
f_qu_approx = quFuni * reshape(f_qu_approx, N_uni, 1);
df_qu = f_qu_approx - f_qu;
rel_err = norm(df_qu) / norm(f_qu);
fprintf("rel_err: %e\n", rel_err);
% -------------------------------------------------------------------------


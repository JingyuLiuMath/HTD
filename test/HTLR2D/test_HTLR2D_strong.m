clear;
close all;
rng(1);

% *************************************************************************
% Settings.
n = 128;
n_leaf = 16;
r = 8;
tol = 1e-10;
ad = "strong";
kappa = 10;
ntest = 3;
% -------------------------------------------------------------------------


% *************************************************************************
% Basic.
N = n^2;
min_points = n_leaf^2;
h = 1 / n;
a_fun = @(xx) zeros(size(xx, 1), 1);
sval = Helm2DSelfValue(h, kappa);
k_fun = @(xx, yy) Helm2D(xx, yy, kappa, sval);
% -------------------------------------------------------------------------


% *************************************************************************
% Preliminary.
I1 = Interval(n);
I2 = Interval(n);
B = Box2D(I1, I2);

x = B.Points();
A = diag(a_fun(x)) + k_fun(x, x) / N;
dense_mem = N^2;

T = ClusterTree2D(B);
T.BuildTree(min_points);
% -------------------------------------------------------------------------


% *************************************************************************
% Construction.
H = HTLR2D(B.I1_.size_, B.I2_.size_, B.I1_.size_, B.I2_.size_);
construct_time = tic;
H.Construct_IE(T, T, ad, a_fun, k_fun, r, tol);
construct_time = toc(construct_time);
fprintf("construct time: %e\n", construct_time);
% -------------------------------------------------------------------------


% *************************************************************************
% Storage.
hmat_mem = H.Storage();
hmat_ratio = hmat_mem / dense_mem;
fprintf("hmat_mem: %e\n", hmat_mem);
fprintf("hmat_ratio: %e\n", hmat_ratio);
% -------------------------------------------------------------------------


% *************************************************************************
% HMultV
num_rhs = 10;
u_ex = randn(N, num_rhs);

mmultv_time = tic;
f_ex = A * u_ex;
mmultv_time = toc(mmultv_time);
fprintf("mmultv_time: %e\n", mmultv_time);

u_ten = reshape(u_ex, [n, n, num_rhs]);
f_ten = H.HMultV(u_ten);
hmultv_time = tic;
for it = 1 : ntest
    f_ten = H.HMultV(u_ten);
end
hmultv_time = toc(hmultv_time) / ntest;
f = reshape(f_ten, N, num_rhs);
fprintf("hmultv_time: %e\n", hmultv_time);

rel_err = sum(vecnorm(f - f_ex) ./ vecnorm(f_ex)) / num_rhs;
fprintf("rel_err: %e\n", rel_err);
% -------------------------------------------------------------------------


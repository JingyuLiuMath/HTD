clear;
close all;
rng(1);

% *************************************************************************
% Settings.
n = 128;
n_leaf = 16;
r = 8;
ad = "strong";
% -------------------------------------------------------------------------


% *************************************************************************
% Basic.
N = n^2;
min_points = n_leaf^2;
h = 1 / n;
a_fun = @(xx) zeros(size(xx, 1), 1);
s_fun = @(xx1, xx2) -reallog(sqrt(xx1.^2 + xx2.^2)) / (2 * pi);
sval = integral2(s_fun, -h / 2, h / 2, -h / 2, h / 2) / (h * h);
k_fun = @(xx, yy) SLP2D(xx, yy, sval);
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
H.Construct_IE(T, T, ad, a_fun, k_fun, r);
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
hmultv_time = tic;
f_ten = H.HMultV(u_ten);
hmultv_time = toc(hmultv_time);
f = reshape(f_ten, N, num_rhs);
fprintf("hmultv_time: %e\n", hmultv_time);

rel_err = sum(vecnorm(f - f_ex) ./ vecnorm(f_ex)) / num_rhs;
fprintf("rel_err: %e\n", rel_err);
% -------------------------------------------------------------------------


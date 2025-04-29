clear;
close all;
rng(1);

% *************************************************************************
% Settings.
n = 16;
n_leaf = 4;
r_or_tol = 2;
ad = "strong";
% -------------------------------------------------------------------------


% *************************************************************************
% Basic.
N = n^3;
min_points = n_leaf^3;
h = 1 / n;
a_fun = @(xx) zeros(size(xx, 1), 1);
s_fun = @(xx1, xx2, xx3) 1 ./ sqrt((xx1.^2 + xx2.^2 + xx3.^2)) / (4 * pi);
sval = 0;
sval = sval + integral3(s_fun, ...
    -h / 2, 0, ...
    -h / 2, 0, ...
    -h / 2, 0);
sval = sval + integral3(s_fun, ...
    0, h / 2, ...
    -h / 2, 0, ...
    -h / 2, 0);
sval = sval + integral3(s_fun, ...
    -h / 2, 0, ...
    0, h / 2, ...
    -h / 2, 0);
sval = sval + integral3(s_fun, ...
    0, h / 2, ...
    0, h / 2, ...
    -h / 2, 0);
sval = sval + integral3(s_fun, ...
    -h / 2, 0, ...
    -h / 2, 0, ...
    0, h / 2);
sval = sval + integral3(s_fun, ...
    0, h / 2, ...
    -h / 2, 0, ...
    0, h / 2);
sval = sval + integral3(s_fun, ...
    -h / 2, 0, ...
    0, h / 2, ...
    0, h / 2);
sval = sval + integral3(s_fun, ...
    0, h / 2, ...
    0, h / 2, ...
    0, h / 2);
sval = sval / h^3;
k_fun = @(xx, yy) SLP3D(xx, yy, sval);
% -------------------------------------------------------------------------


% *************************************************************************
% Preliminary.
I1 = Interval(n);
I2 = Interval(n);
I3 = Interval(n);
B = Box3D(I1, I2, I3);

x = B.Points();
A = diag(a_fun(x)) + k_fun(x, x) / N;
dense_mem = N^2;

T = ClusterTree3D(B);
T.BuildTree(min_points);
p = T.p_;
q = T.q_;
% -------------------------------------------------------------------------


% *************************************************************************
% Construction.
H = HMAT3D(B.size_, B.size_);
construct_time = tic;
H.Construct_IE(T, T, ad, a_fun, k_fun, r_or_tol);
construct_time = toc(construct_time);
fprintf("construct time: %e\n", construct_time);
H.PlotHMat();
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

u = u_ex(q, :);
hmultv_time = tic;
f = H.HMultV(u);
hmultv_time = toc(hmultv_time);
f = f(p, :);
fprintf("hmultv_time: %e\n", hmultv_time);

rel_err = sum(vecnorm(f - f_ex) ./ vecnorm(f_ex)) / num_rhs;
fprintf("rel_err: %e\n", rel_err);
% -------------------------------------------------------------------------


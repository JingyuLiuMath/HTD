clear;
close all;
rng(1);

n = 16;
n_leaf = 4;
r = 2;
tol = 1e-10;

min_points = n_leaf^2;
a_fun = @(xx) zeros(size(xx, 1), 1);
k_fun = @(xx, yy) Gaussian(xx, yy, sqrt(2));

I = Interval(n);
B = Box2D(I, I);

T = ClusterTree2D(B);
T.BuildTree(min_points);

ad = "weak";
H = HMAT2D(B.size_, B.size_);
H.Construct_IE(T, T, ad, a_fun, k_fun, r, tol);
H.PlotHMat();
set(gcf, "Color", "w");
saveas(gcf, "./figure/Hmatrix_weak.png", "png");
exportgraphics(gcf, "./figure/Hmatrix_weak.pdf", ...
    "ContentType", "vector");

ad = "strong";
H = HMAT2D(B.size_, B.size_);
H.Construct_IE(T, T, ad, a_fun, k_fun, r, tol);
H.PlotHMat();
set(gcf, "Color", "w");
saveas(gcf, "./figure/Hmatrix_strong.png", "png");
exportgraphics(gcf, "./figure/Hmatrix_strong.pdf", ...
    "ContentType", "vector");

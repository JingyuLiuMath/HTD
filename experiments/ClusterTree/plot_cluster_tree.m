clear;
close all;
rng(1);

n = 16;
n_leaf = 4;

min_points = n_leaf^2;

I = Interval(n);
B = Box2D(I, I);

x1 = I.Points();
x2 = I.Points();
x = TensorProduct2D(x1, x2);

T = ClusterTree2D(B);
T.BuildTree(min_points);

T.PlotTree();
saveas(gcf, "./figure/leaf_cluster_tree.eps", "epsc");
clear;
close all;
rng(1);

n = 64;
n_leaf = 4;
min_points = n_leaf^2;

I1 = Interval(n);
I2 = Interval(n);
B = Box2D(I1, I2);

x1 = I1.Points();
x2 = I2.Points();
x = TensorProduct2D(x1, x2);

T = ClusterTree2D(B);
T.BuildTree(min_points);

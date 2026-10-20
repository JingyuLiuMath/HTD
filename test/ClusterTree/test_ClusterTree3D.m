clear;
close all;
rng(1);

n = 64;
n_leaf = 4;
min_points = n_leaf^2;

I1 = Interval(n);
I2 = Interval(n);
I3 = Interval(n);
B = Box3D(I1, I2, I3);

x1 = I1.Points();
x2 = I2.Points();
x3 = I3.Points();
x = TensorProduct3D(x1, x2, x3);

T = ClusterTree3D(B);
T.BuildTree(min_points);

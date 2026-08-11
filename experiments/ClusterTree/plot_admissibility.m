clear;
close all;
rng(1);

n = 16;
n_leaf = 4;

min_points = n_leaf^2;
block_size = n / n_leaf;
h = 1 / n;

I = Interval(n);
B = Box2D(I, I);

x1 = I.Points();
x2 = I.Points();
x = TensorProduct2D(x1, x2);

T = ClusterTree2D(B);
T.BuildTree(min_points);

leaf_x1 = 2;
I1_leaf = Interval(n, ...
    1 + (leaf_x1 - 1) * block_size, ...
    1 + leaf_x1 * block_size - 1);
leaf_x2 = 2;
I2_leaf = Interval(n, ...
    1 + (leaf_x2 - 1) * block_size, ...
    1 + leaf_x2 * block_size - 1);
target_node = Box2D(I1_leaf, I2_leaf);

% weak
T.PlotAdmissibility(target_node, "weak");

hold on;
for i = 0 : block_size
    xline(i * h * block_size, ...
        "LineStyle", "--", ...
        "color", [0.15, 0.15, 0.15], ...
        "Linewidth", 2);
end
for j = 0 : block_size
    yline(j * h * block_size, ...
        "LineStyle", "--", ...
        "color", [0.15, 0.15, 0.15], ...
        "Linewidth", 2);
end
hold off;

xlim([0, 1]);
ylim([0, 1]);
axis off;
set(gcf, "Color", "w");

saveas(gcf, "./figure/weak_admissibility.png", "png");
exportgraphics(gcf, "./figure/weak_admissibility.pdf", ...
    "ContentType", "vector");

% strong
T.PlotAdmissibility(target_node, "strong");

hold on;
for i = 0 : block_size
    xline(i * h * block_size, ...
        "LineStyle", "--", ...
        "color", [0.15, 0.15, 0.15], ...
        "Linewidth", 2);
end
for j = 0 : block_size
    yline(j * h * block_size, ...
        "LineStyle", "--", ...
        "color", [0.15, 0.15, 0.15], ...
        "Linewidth", 2);
end
hold off;

xlim([0, 1]);
ylim([0, 1]);
axis off;
set(gcf, "Color", "w");

saveas(gcf, "./figure/strong_admissibility.png", "png");
exportgraphics(gcf, "./figure/strong_admissibility.pdf", ...
    "ContentType", "vector");

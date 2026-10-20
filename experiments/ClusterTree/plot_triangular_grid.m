clear;
close all;
rng(1);

n_qu = 8;
[N_qu, qu_grid, x_qu, v1, v2, v3] = TriangularQUGrid2D(n_qu, 1);
saveas(gcf, "./figure/triangulation.png", "png");
exportgraphics(gcf, "./figure/triangulation.pdf", ...
    "ContentType", "vector");

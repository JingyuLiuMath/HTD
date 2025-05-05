function [N, qu_grid, x_qu, v1, v2, v3] = TriangularQUGrid2D(n, plot_flag)

arguments (Input)
    n (1, 1) double;
    plot_flag (1, 1) double = 0;
end

arguments (Output)
    N (1, 1) double;
    qu_grid (:, 1) polyshape;
    x_qu (:, 2) double;
    v1 (:, 2) double;
    v2 (:, 2) double;
    v3 (:, 2) double
end

h = 1 / n;
[tx1, tx2] = meshgrid(h : h : (1 - h));
tx1 = tx1(:);
tx2 = tx2(:);
P = [tx1, tx2];
% P = P + h / 8 * (2 * rand(size(P, 1), 2) - 1);
P = P + h / 8 * randn(size(P, 1), 2);
uni_edge = (h : h : (1 - h))';
zero_edge = zeros(n - 1, 1);
one_edge = ones(n - 1, 1);
north_edge = [uni_edge, one_edge];
south_edge = [uni_edge, zero_edge];
west_edge = [zero_edge, uni_edge];
east_edge = [one_edge, uni_edge];
corner_points = [0, 0; 1, 0; 1, 1; 0, 1];
P = [P; north_edge; south_edge; west_edge; east_edge; corner_points];

DT = delaunayTriangulation(P);
N = DT.size(1);  % N_real = 2 * nreal^2;
v1 = DT.Points(DT.ConnectivityList(:, 1), :);
v2 = DT.Points(DT.ConnectivityList(:, 2), :);
v3 = DT.Points(DT.ConnectivityList(:, 3), :);
x_qu = (v1 + v2 + v3) / 3;

if plot_flag == 1
    figure();
    triplot(DT, ...
        'LineWidth', 1, ...
        'color', [0 0.4470 0.7410]);
    hold on;
    plot(x_qu(:, 1), x_qu(:, 2), ...
        'color', [0.8500 0.3250 0.0980], ...
        'LineStyle', 'none', ...
        'Marker', "*");
    axis equal;
    xlim([0, 1]);
    ylim([0, 1]);
    axis off;
end

qu_grid = repmat(polyshape(), N, 1);
for i = 1 : N
    qu_grid(i) = polyshape(...
        [v1(i, 1), v2(i, 1), v3(i, 1)], [v1(i, 2), v2(i, 2), v3(i, 2)]);
end

end
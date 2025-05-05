close all;
clear;
rng(1);

fprintf("H2DSQ Problem\n");

n_list = [64, 128, 256, 512];
num_n = length(n_list);

for i = 1 : num_n
    n_qu = n_list(i);
    disp("current n: " + n_qu);

    [N_qu, qu_grid, x_qu, v1, v2, v3] = TriangularQUGrid2D(n_qu);
    area_qu = qu_grid.area;

    file_name = "./data/problem/" + string(n_qu) + ".mat";
    save(file_name, "N_qu", "qu_grid", "x_qu", "v1", "v2", "v3", "area_qu");
end
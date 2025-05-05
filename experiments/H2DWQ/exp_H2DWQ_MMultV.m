%% Setting.
clear;
close all;

fprintf("H2DWQ MMV\n");

n_list = [64, 128, 256, 512];
num_n = length(n_list);

block_size = 65536;
%% Loop.
for i = 1 : num_n
    n_qu = n_list(i);
    fprintf("current n_qu: %d\n", n_qu);

    file_name = "./data/problem/" + string(n_qu) + ".mat";
    load(file_name);

    u_fun = @(x1, x2) 1 + 0.5 * exp(...
        -(x1 - 0.3).^2 - (x2 - 0.6).^2 + sin(5 .* x1 .* x2));
    u_qu = u_fun(x_qu(:, 1), x_qu(:, 2));

    a_fun = @(xx) zeros(size(xx, 1), 1);
    k_fun = @(xx, yy) Gaussian(xx, yy, sqrt(2));

    f_qu = a_fun(x_qu) .* u_qu;

    num_block = ceil(N_qu / block_size);
    roff = 0;
    for rit = 1 : num_block
        rind = (roff + 1) : min(roff + block_size, N_qu);
        coff = 0;
        for cit = 1 : num_block
            cind = (coff + 1) : min(coff + block_size, N_qu);
            tmp_mat = k_fun(x_qu(rind, :), x_qu(cind, :)) .* area_qu(cind).';
            f_qu(rind, :) = f_qu(rind, :) + tmp_mat * u_qu(cind, :);
            coff = coff + block_size;
        end
        roff = roff + block_size;
    end

    file_name = "./data/mmv/" + string(n_qu) + ".mat";
    save(file_name, "u_fun", "u_qu", "f_qu");
end


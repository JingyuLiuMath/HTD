close all;
clear;
rng(1);

fprintf("H3DS Problem\n");

n_list = [32, 64, 128, 160, 256];
num_n = length(n_list);

block_size = 65536;
nsample = 1000;
n_sample_threshold = 64;

for i = 1 : num_n
    n = n_list(i);
    disp("current n: " + n)

    N = n^3;
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

    I = Interval(n);
    B = Box3D(I, I, I);
    x = B.Points();

    u_ex = randn(N, 1);

    rand_rind = randperm(N, nsample);
    num_block = ceil(N / block_size);
    if n <= n_sample_threshold
        is_sampled = false;
        f_ex = a_fun(x) .* u_ex;

        roff = 0;
        for rit = 1 : num_block
            rind = (roff + 1) : min(roff + block_size, N);
            coff = 0;
            for cit = 1 : num_block
                cind = (coff + 1) : min(coff + block_size, N);

                f_ex(rind, :) = f_ex(rind, :) ...
                    + k_fun(x(rind, :), x(cind, :)) / N * u_ex(cind, :);

                coff = coff + block_size;
            end
            roff = roff + block_size;
        end
    else
        is_sampled = true;
        f_ex = a_fun(x(rand_rind, :)) .* u_ex(rand_rind, :);

        num_rblock = ceil(nsample / block_size);

        roff = 0;
        for rit = 1 : num_rblock
            rind = (roff + 1) : min(roff + block_size, nsample);
            coff = 0;
            for cit = 1 : num_block
                cind = (coff + 1) : min(coff + block_size, N);

                f_ex(rind, :) = f_ex(rind, :) ...
                    + k_fun(x(rand_rind(rind), :), x(cind, :)) / N * u_ex(cind, :);

                coff = coff + block_size;
            end
            roff = roff + block_size;
        end
    end
    file_name = "./data/problem/" + string(n) + ".mat";
    save(file_name, ...
        "u_ex", "f_ex", ...
        "is_sampled", "rand_rind");
end
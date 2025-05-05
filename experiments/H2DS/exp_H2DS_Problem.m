close all;
clear;
rng(1);

fprintf("H2DS Problem\n");

n_list = [256, 512, 1024, 2048, 3200, 4096];
num_n = length(n_list);

block_size = 65536;
nsample = 1000;
n_sample_threshold = 512;

for i = 1 : num_n
    n = n_list(i);
    fprintf("current n: %d\n", n);
    
    N = n^2;
    h = 1 / n;

    a_fun = @(xx) zeros(size(xx, 1), 1);
    s_fun = @(xx1, xx2) -reallog(sqrt(xx1.^2 + xx2.^2)) / (2 * pi);
    sval = integral2(s_fun, -h / 2, h / 2, -h / 2, h / 2) / (h * h);
    k_fun = @(xx, yy) SLP2D(xx, yy, sval);

    I = Interval(n);
    B = Box2D(I, I);
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
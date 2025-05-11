clear;
close all;

fprintf("H2DSQ Print\n");

n_list = [64, 128, 256, 512];
num_n = length(n_list);

rho_list = [2, 3, 4];
num_rho = length(rho_list);

quFuni_err_list = zeros(num_n, num_rho);
uniFqu_err_list = zeros(num_n, num_rho);
for i = 1 : num_n
    n_qu = n_list(i);
    for j = 1 : num_rho
        rho = rho_list(j);
        file_name = "./data/intermatrix/" ...
            + string(n_qu) + "_" + string(rho) + ".mat";
        load(file_name);
        quFuni_err_list(i, j) = rel_err_quFuni;
        uniFqu_err_list(i, j) = rel_err_uniFqu;
    end
end

fprintf("\n\n");
for i = 1 : num_n
    n_qu = n_list(i);
    fprintf("\\multirow{3}{*}{%d} ", n_qu);
    for j = 1 : num_rho
        rho = rho_list(j);
        fprintf("& %d ", rho);
        fprintf("& %.1e ", quFuni_err_list(i, j));
        fprintf("& %.1e ", uniFqu_err_list(i, j));
        fprintf("\\\\ \n");
    end
    fprintf("\\midrule \n")
end
fprintf("\n\n");
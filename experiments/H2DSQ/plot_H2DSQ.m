%% Setting.
clear;
close all;

fprintf("H2DSQ Plot\n");

n_list = [64, 128, 256, 512];
num_n = length(n_list);
N_list = 2 * n_list.^2;

rho_list = [2, 3, 4];
num_rho = length(rho_list);

err_list = zeros(num_n, num_rho);

n_leaf = 16;
r = 8;
ad = "weak";
min_points = n_leaf^2;
%% Loop.
for i = 1 : num_n
    n_qu = n_list(i);
    for j = 1 : num_rho
        rho = rho_list(j);
        file_name = "./data/hmv/" ...
            + string(n_qu) + "_" + string(rho) + ".mat";
        load(file_name);

        err_list(i, j) = rel_err;
    end
end

figure();
for j = 1 : num_rho
    rho = rho_list(j);
    loglog(N_list, err_list(:, j), ...
        "LineWidth", 2, ...
        "Marker", "x", ...
        "DisplayName", "\rho = " + string(rho));
    hold on;
end
xlabel("$N$", "Interpreter", "latex");
ylabel("$e_{\mathrm{a}}$", "Interpreter", "latex");
legend("Location", "northeast");
set(gca, 'FontSize', 30);
saveas(gcf, "./figure/H2DSQ_err.png", "png");
saveas(gcf, "./figure/H2DSQ_err.eps", "epsc");
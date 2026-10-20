clear;
close all;

exp_H2DSQ_Settings;

fprintf("H2DSQ Plot\n");

N_list = 2 * n_list.^2;

err_list = zeros(num_n, num_rho);
for i = 1 : num_n
    n_qu = n_list(i);
    for j = 1 : num_rho
        rho = rho_list(j);
        file_name = "./data/hmv/" ...
            + string(n_qu) + "_" + string(rho) + ".mat";
        data = load(file_name);
        if isfield(data, "result")
            data = data.result;
        end

        err_list(i, j) = data.rel_err;
    end
end

marker_list = ['o', 's', 'd'];
figure();
for j = 1 : num_rho
    rho = rho_list(j);
    loglog(N_list, err_list(:, j), ...
        "LineWidth", 2, "MarkerSize", 20, ...
        "Marker", marker_list(j), ...
        "DisplayName", "\rho = " + string(rho));
    hold on;
end
xlabel("$N$", "Interpreter", "latex");
ylabel("$e_{\mathrm{a}}$", "Interpreter", "latex");
legend("Location", "northeast");
set(gca, 'FontSize', 30);
saveas(gcf, "./figure/H2DSQ_err.png", "png");
exportgraphics(gcf, "./figure/H2DSQ_err.pdf", ...
    "ContentType", "vector");

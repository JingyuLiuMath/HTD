clear;
close all;
exp_LR3D_Settings;

ad_list = ["NBR", "WS"];
num_ad = length(ad_list);

ker_list = ["Gaussian", "SLP", "Helm"];
num_ker = length(ker_list);

for it_ad = 1 : num_ad
    for it_ker = 1 : num_ker
        ad = ad_list(it_ad);
        ker = ker_list(it_ker);

        svd_err_list = zeros(num_r, 1);
        inter_err_list = zeros(num_r, 1);
        tsvd_err_list = zeros(num_r, 1);

        for it_r = 1 : num_r
            r = r_list(it_r);
            file_name = "./data/" + ad + "_" + ker ...
                + "/LR_" + string(r) + ".mat";
            data = load(file_name);
            if isfield(data, "result")
                data = data.result;
            end
            svd_err_list(it_r) = data.svd_err;
            inter_err_list(it_r) = data.inter_err;
            tsvd_err_list(it_r) = data.tsvd_err;
        end

        figure();
        semilogy(r_list, inter_err_list, ...
            "Marker", "o", ...
            "LineWidth", 2, "MarkerSize", 20, ...
            "DisplayName", "INTERP");
        hold on;
        semilogy(r_list, svd_err_list, ...
            "Marker", "s", ...
            "LineWidth", 2, "MarkerSize", 20, ...
            "DisplayName", "SVD");
        semilogy(r_list, tsvd_err_list, ...
            "Marker", "d", ...
            "LineWidth", 2, "MarkerSize", 20, ...
            "DisplayName", "STHOSVD");
        hold off;
        if ad == "NBR" && (ker == "Helm" || ker == "SLP")
            legend("Location", "southwest");
        else
            legend("Location", "northeast");
        end
        ylabel("relative error");
        xlabel("p");
        xlim([r_list(1), r_list(end)]);
        ylim([1e-15, 1e1]);
        set(gca, 'FontSize', 22);
        figure_name = "./figure/" + ad + "_" + ker + "_3D";
        saveas(gcf, figure_name + ".png", "png");
        exportgraphics(gcf, figure_name + ".pdf", ...
            "ContentType", "vector");
    end
end

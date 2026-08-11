clear;
close all;

fprintf("H2DS Plot\n");

hmat_n_list = [256, 512, 1024, 2048, 4096];
num_hmat_n = length(hmat_n_list);
hmat_N_list = hmat_n_list.^2;

htlr_n_list = [256, 512, 1024, 2048, 4096];
num_htlr_n = length(htlr_n_list);
htlr_N_list = htlr_n_list.^2;

r = 8;

hmat_construct_time_list = zeros(num_hmat_n, 1);
hmat_hmultv_time_list = zeros(num_hmat_n, 1);
hmat_hmem_list = zeros(num_hmat_n, 1);
hmat_hmulv_err_list = zeros(num_hmat_n, 1);
hmat_hmulv_rand_err_list = zeros(num_hmat_n, 1);
hmat_rand_ind = 1;

htlr_construct_time_list = zeros(num_htlr_n, 1);
htlr_hmultv_time_list = zeros(num_htlr_n, 1);
htlr_hmem_list = zeros(num_htlr_n, 1);
htlr_hmulv_err_list = zeros(num_htlr_n, 1);
htlr_hmulv_rand_err_list = zeros(num_htlr_n, 1);
htlr_rand_ind = 1;

for it_n = 1 : num_hmat_n
    n = hmat_n_list(it_n);
    file_name = "./data/hmat/" + string(n) + "_r_" + string(r) + ".mat";
    hmat_data = load(file_name);
    if isfield(hmat_data, "result")
        hmat = hmat_data.result;
    else
        hmat = hmat_data;
    end
    
    hmat_construct_time_list(it_n) = hmat.construct_time;
    hmat_hmultv_time_list(it_n) = hmat.hmultv_time;
    hmat_hmem_list(it_n) = hmat.hmat_mem;
    hmat_hmulv_err_list(it_n) = hmat.err;
    hmat_hmulv_rand_err_list(it_n) = hmat.rand_err;
    if hmat.err ~= 0
        hmat_rand_ind = it_n;
    end
end

for it_n = 1 : num_htlr_n
    n = htlr_n_list(it_n);
    file_name = "./data/htlr/" + string(n) + "_r_" + string(r) + ".mat";
    htlr_data = load(file_name);
    if isfield(htlr_data, "result")
        htlr = htlr_data.result;
    else
        htlr = htlr_data;
    end
    
    htlr_construct_time_list(it_n) = htlr.construct_time;
    htlr_hmultv_time_list(it_n) = htlr.hmultv_time;
    htlr_hmem_list(it_n) = htlr.hmat_mem;
    htlr_hmulv_err_list(it_n) = htlr.err;
    htlr_hmulv_rand_err_list(it_n) = htlr.rand_err;
    if htlr.err ~= 0
        htlr_rand_ind = it_n;
    end
end

figure();
loglog(hmat_N_list, hmat_construct_time_list, ...
        "LineWidth", 2, "MarkerSize", 20, ...
        "Marker", "*", ...
        "DisplayName", "$\mathcal{H}$-matrix");
hold on;
loglog(htlr_N_list, htlr_construct_time_list, ...
        "LineWidth", 2, "MarkerSize", 20, ...
        "Marker", "x", ...
        "DisplayName", "HTD");
ref_construct_complexity = htlr_N_list;
ref_construct_complexity = ref_construct_complexity / ref_construct_complexity(1) * htlr_construct_time_list(1) / 2;
loglog(htlr_N_list(2 : end - 1), ref_construct_complexity(2 : end  -1), ...
    "LineWidth", 2, "MarkerSize", 20, ...
    "LineStyle", "--", ...
    "DisplayName", "$\mathcal{O}(N)$");
% title("construct time");
xlabel("$N$", "Interpreter", "latex");
ylabel("$t_{\mathrm{c}}$ (s)", "Interpreter", "latex");
xticks([10^5, 10^6, 10^7]);
xtickformat('%.0e');
yticks([10^0, 10^1, 10^2, 10^3]);
ytickformat('%.0e');
legend("Location", "southeast", "Interpreter", "latex");
set(gca, 'FontSize', 30);
saveas(gcf, "./figure/H2DS_construct_time.png", "png");
exportgraphics(gcf, "./figure/H2DS_construct_time.pdf", ...
    "ContentType", "vector");

figure();
loglog(hmat_N_list, hmat_hmultv_time_list, ...
        "LineWidth", 2, "MarkerSize", 20, ...
        "Marker", "*", ...
        "DisplayName", "$\mathcal{H}$-matrix");
hold on;
loglog(htlr_N_list, htlr_hmultv_time_list, ...
        "LineWidth", 2, "MarkerSize", 20, ...
        "Marker", "x", ...
        "DisplayName", "HTD");
ref_hmultv_complexity_NlogN = htlr_N_list .* log2(htlr_N_list);
ref_hmultv_complexity_NlogN = ref_hmultv_complexity_NlogN ...
    / ref_hmultv_complexity_NlogN(1) * htlr_hmultv_time_list(1) / 2;
loglog(htlr_N_list(2 : end - 1), ref_hmultv_complexity_NlogN(2 : end  -1), ...
    "LineWidth", 2, "MarkerSize", 20, ...
    "LineStyle", "--", ...
    "DisplayName", "$\mathcal{O}(N \log N)$");
% title("apply time");
xlabel("$N$", "Interpreter", "latex");
ylabel("$t_{\mathrm{a}}$ (s)", "Interpreter", "latex");
xticks([10^5, 10^6, 10^7]);
xtickformat('%.0e');
yticks([10^0, 10^1, 10^2, 10^3]);
ytickformat('%.0e');
legend("Location", "southeast", "Interpreter", "latex");
set(gca, 'FontSize', 25);
saveas(gcf, "./figure/H2DS_hmultv_time.png", "png");
exportgraphics(gcf, "./figure/H2DS_hmultv_time.pdf", ...
    "ContentType", "vector");

figure();
loglog(hmat_N_list, hmat_hmem_list, ...
        "LineWidth", 2, "MarkerSize", 20, ...
        "Marker", "*", ...
        "DisplayName", "$\mathcal{H}$-matrix");
hold on;
loglog(htlr_N_list, htlr_hmem_list, ...
        "LineWidth", 2, "MarkerSize", 20, ...
        "Marker", "x", ...
        "DisplayName", "HTD");
ref_hmem_complexity = htlr_N_list;
ref_hmem_complexity = ref_hmem_complexity / ref_hmem_complexity(1) * htlr_hmem_list(1) / 2;
loglog(htlr_N_list(2 : end - 1), ref_hmem_complexity(2 : end  -1), ...
    "LineWidth", 2, "MarkerSize", 20, ...
    "LineStyle", "--", ...
    "DisplayName", "$\mathcal{O}(N)$");
% title("memory");
xlabel("$N$", "Interpreter", "latex");
ylabel("$m_{\mathrm{h}}$ (GB)", "Interpreter", "latex");
xticks([10^5, 10^6, 10^7]);
xtickformat('%.0e');
yticks([10^0, 10^1, 10^2, 10^3]);
ytickformat('%.0e');
legend("Location", "southeast", "Interpreter", "latex");
set(gca, 'FontSize', 30);
saveas(gcf, "./figure/H2DS_memory.png", "png");
exportgraphics(gcf, "./figure/H2DS_memory.pdf", ...
    "ContentType", "vector");


figure();
loglog(hmat_N_list, hmat_hmulv_rand_err_list, ...
        "LineWidth", 2, "MarkerSize", 20, ...
        "Marker", "*", ...
        "DisplayName", "$\mathcal{H}$-matrix");
hold on;
loglog(htlr_N_list, htlr_hmulv_rand_err_list, ...
        "LineWidth", 2, "MarkerSize", 20, ...
        "Marker", "x", ...
        "DisplayName", "HTD");
% title("relative apply error");
xlabel("$N$", "Interpreter", "latex");
ylabel("$e_{\mathrm{a}; \mathrm{r}}$", "Interpreter", "latex");
legend("Location", "southeast", "Interpreter", "latex");
set(gca, 'FontSize', 30);
saveas(gcf, "./figure/H2DS_err.png", "png");
exportgraphics(gcf, "./figure/H2DS_err.pdf", ...
    "ContentType", "vector");

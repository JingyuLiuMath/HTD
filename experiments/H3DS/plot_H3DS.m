clear;
close all;

fprintf("H3DS Plot\n");

hmat_n_list = [32, 64];
num_hmat_n = length(hmat_n_list);
hmat_N_list = hmat_n_list.^3;

htlr_n_list = [32, 64, 128];
num_htlr_n = length(htlr_n_list);
htlr_N_list = htlr_n_list.^3;

r = 4;

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

hmat_hmem_list = hmat_hmem_list / 1024^3 * 8;
htlr_hmem_list = htlr_hmem_list / 1024^3 * 8;

figure();
loglog(htlr_N_list, htlr_construct_time_list, ...
        "LineWidth", 2, "MarkerSize", 20, ...
        "Marker", "x", ...
        "DisplayName", "HTLR");
hold on;
loglog(hmat_N_list, hmat_construct_time_list, ...
        "LineWidth", 2, "MarkerSize", 20, ...
        "Marker", "*", ...
        "DisplayName", "HMAT");
tmp_N_list = [(htlr_N_list(1) + htlr_N_list(2)) / 3, htlr_N_list(2), (htlr_N_list(2) + htlr_N_list(3)) / 2];
ref_construct_complexity = tmp_N_list;
ref_construct_complexity = ref_construct_complexity / ref_construct_complexity(2) * htlr_construct_time_list(2) / 2;
loglog(tmp_N_list, ref_construct_complexity, ...
    "LineWidth", 2, "MarkerSize", 20, ...
    "LineStyle", "--", ...
    "DisplayName", "O(N)");
% title("construct time");
xlabel("$N$", "Interpreter", "latex");
ylabel("$t_{\mathrm{c}}$ (s)", "Interpreter", "latex");
xticks([10^4, 10^5, 10^6]);
xtickformat('%.0e');
yticks([10^2, 10^3, 10^4]);
ytickformat('%.0e');
legend("Location", "southeast");
set(gca, 'FontSize', 30);
saveas(gcf, "./figure/H3DS_construct_time.png", "png");
saveas(gcf, "./figure/H3DS_construct_time.eps", "epsc");

figure();
loglog(htlr_N_list, htlr_hmultv_time_list, ...
        "LineWidth", 2, "MarkerSize", 20, ...
        "Marker", "x", ...
        "DisplayName", "HTLR");
hold on;
loglog(hmat_N_list, hmat_hmultv_time_list, ...
        "LineWidth", 2, "MarkerSize", 20, ...
        "Marker", "*", ...
        "DisplayName", "HMAT");
tmp_N_list = [(htlr_N_list(1) + htlr_N_list(2)) / 3, htlr_N_list(2), (htlr_N_list(2) + htlr_N_list(3)) / 2];
ref_hmultv_complexity = tmp_N_list .* log2(tmp_N_list);
ref_hmultv_complexity = ref_hmultv_complexity / ref_hmultv_complexity(2) * htlr_hmultv_time_list(2) / 2;
loglog(tmp_N_list, ref_hmultv_complexity, ...
    "LineWidth", 2, "MarkerSize", 20, ...
    "LineStyle", "--", ...
    "DisplayName", "O(N log N)");
% title("apply time");
xlabel("$N$", "Interpreter", "latex");
ylabel("$t_{\mathrm{a}}$ (s)", "Interpreter", "latex");
xticks([10^4, 10^5, 10^6]);
xtickformat('%.0e');
yticks([10^0, 10^1, 10^2, 10^3, 10^4]);
ytickformat('%.0e');
legend("Location", "southeast");
set(gca, 'FontSize', 30);
saveas(gcf, "./figure/H3DS_hmultv_time.png", "png");
saveas(gcf, "./figure/H3DS_hmultv_time.eps", "epsc");

figure();
loglog(htlr_N_list, htlr_hmem_list, ...
        "LineWidth", 2, "MarkerSize", 20, ...
        "Marker", "x", ...
        "DisplayName", "HTLR");
hold on;
loglog(hmat_N_list, hmat_hmem_list, ...
        "LineWidth", 2, "MarkerSize", 20, ...
        "Marker", "*", ...
        "DisplayName", "HMAT");
tmp_N_list = [(htlr_N_list(1) + htlr_N_list(2)) / 3, htlr_N_list(2), (htlr_N_list(2) + htlr_N_list(3)) / 2];
ref_hmem_complexity = tmp_N_list;
ref_hmem_complexity = ref_hmem_complexity / ref_hmem_complexity(2) * htlr_hmem_list(2) / 2;
loglog(tmp_N_list, ref_hmem_complexity, ...
        "LineWidth", 2, "MarkerSize", 20, ...
        "LineStyle", "--", ...
        "DisplayName", "O(N)");
% title("memory");
xlabel("$N$", "Interpreter", "latex");
ylabel("$m_{\mathrm{h}}$ (GB)", "Interpreter", "latex");
xticks([10^4, 10^5, 10^6]);
xtickformat('%.0e');
yticks([10^0, 10^1, 10^2, 10^3, 10^4]);
ytickformat('%.0e');
legend("Location", "southeast");
set(gca, 'FontSize', 30);
saveas(gcf, "./figure/H3DS_memory.png", "png");
saveas(gcf, "./figure/H3DS_memory.eps", "epsc");


figure();
loglog(htlr_N_list, htlr_hmulv_rand_err_list, ...
        "LineWidth", 2, "MarkerSize", 20, ...
        "Marker", "x", ...
        "DisplayName", "HTLR");
hold on;
loglog(hmat_N_list, hmat_hmulv_rand_err_list, ...
        "LineWidth", 2, "MarkerSize", 20, ...
        "Marker", "*", ...
        "DisplayName", "HMAT");
% title("relative apply error");
xlabel("$N$", "Interpreter", "latex");
ylabel("$e_{\mathrm{a}; \mathrm{r}}$", "Interpreter", "latex");
legend("Location", "southeast");
set(gca, 'FontSize', 30);
saveas(gcf, "./figure/H3DS_err.png", "png");
saveas(gcf, "./figure/H3DS_err.eps", "epsc");

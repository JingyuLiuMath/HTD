clear;
close all;

fprintf("H2DS Plot\n");

hmat_n_list = [256, 512, 1024, 2048];
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
    load(file_name);
    
    hmat_construct_time_list(it_n) = construct_time;
    hmat_hmultv_time_list(it_n) = hmultv_time;
    hmat_hmem_list(it_n) = hmat_mem;
    hmat_hmulv_err_list(it_n) = err;
    hmat_hmulv_rand_err_list(it_n) = rand_err;
    if err ~= 0
        hmat_rand_ind = it_n;
    end
end

for it_n = 1 : num_htlr_n
    n = htlr_n_list(it_n);
    file_name = "./data/htlr/" + string(n) + "_r_" + string(r) + ".mat";
    load(file_name);
    
    htlr_construct_time_list(it_n) = construct_time;
    htlr_hmultv_time_list(it_n) = hmultv_time;
    htlr_hmem_list(it_n) = hmat_mem;
    htlr_hmulv_err_list(it_n) = err;
    htlr_hmulv_rand_err_list(it_n) = rand_err;
    if err ~= 0
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
ref_construct_complexity = htlr_N_list;
ref_construct_complexity = ref_construct_complexity / ref_construct_complexity(1) * htlr_construct_time_list(1) / 2;
loglog(htlr_N_list(2 : end - 1), ref_construct_complexity(2 : end  -1), ...
    "LineWidth", 2, "MarkerSize", 20, ...
    "LineStyle", "--", ...
    "DisplayName", "O(N)");
% title("construct time");
xlabel("$N$", "Interpreter", "latex");
ylabel("$t_{\mathrm{c}}$ (s)", "Interpreter", "latex");
xticks([10^5, 10^6, 10^7]);
xtickformat('%.0e');
yticks([10^0, 10^1, 10^2, 10^3]);
ytickformat('%.0e');
legend("Location", "southeast");
set(gca, 'FontSize', 30);
saveas(gcf, "./figure/H2DS_construct_time.png", "png");
saveas(gcf, "./figure/H2DS_construct_time.eps", "epsc");

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
ref_hmultv_complexity_NlogN = htlr_N_list .* log2(htlr_N_list);
ref_hmultv_complexity_NlogN = ref_hmultv_complexity_NlogN / ref_hmultv_complexity_NlogN(1) * htlr_hmultv_time_list(1);
ref_hmultv_complexity_N = htlr_N_list;
ref_hmultv_complexity_N = ref_hmultv_complexity_N / ref_hmultv_complexity_N(1) * htlr_hmultv_time_list(1) * 0.8;
loglog(htlr_N_list(2 : end - 1), ref_hmultv_complexity_NlogN(2 : end  -1), ...
    "LineWidth", 2, "MarkerSize", 20, ...
    "LineStyle", "--", ...
    "DisplayName", "O(N log N)");
loglog(htlr_N_list(2 : end - 1), ref_hmultv_complexity_N(2 : end  -1), ...
"LineWidth", 2, "MarkerSize", 20, ...
"LineStyle", "-.", ...
"DisplayName", "O(N)");
% title("apply time");
xlabel("$N$", "Interpreter", "latex");
ylabel("$t_{\mathrm{a}}$ (s)", "Interpreter", "latex");
xticks([10^5, 10^6, 10^7]);
xtickformat('%.0e');
yticks([10^0, 10^1, 10^2, 10^3]);
ytickformat('%.0e');
legend("Location", "southeast");
set(gca, 'FontSize', 25);
saveas(gcf, "./figure/H2DS_hmultv_time.png", "png");
saveas(gcf, "./figure/H2DS_hmultv_time.eps", "epsc");

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
ref_hmem_complexity = htlr_N_list;
ref_hmem_complexity = ref_hmem_complexity / ref_hmem_complexity(1) * htlr_hmem_list(1) / 2;
loglog(htlr_N_list(2 : end - 1), ref_hmem_complexity(2 : end  -1), ...
    "LineWidth", 2, "MarkerSize", 20, ...
    "LineStyle", "--", ...
    "DisplayName", "O(N)");
% title("memory");
xlabel("$N$", "Interpreter", "latex");
ylabel("$m_{\mathrm{h}}$ (GB)", "Interpreter", "latex");
xticks([10^5, 10^6, 10^7]);
xtickformat('%.0e');
yticks([10^0, 10^1, 10^2, 10^3]);
ytickformat('%.0e');
legend("Location", "southeast");
set(gca, 'FontSize', 30);
saveas(gcf, "./figure/H2DS_memory.png", "png");
saveas(gcf, "./figure/H2DS_memory.eps", "epsc");


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
saveas(gcf, "./figure/H2DS_err.png", "png");
saveas(gcf, "./figure/H2DS_err.eps", "epsc");
clear;
close all;

fprintf("H2DW Plot\n");

hmat_n_list = [16, 32, 64, 128];
num_hmat_n = length(hmat_n_list);
hmat_N_list = hmat_n_list.^2;

htlr_n_list = [16, 32, 64, 128];
num_htlr_n = length(htlr_n_list);
htlr_N_list = htlr_n_list.^2;

r = 8;

hmat_construct_time_list = zeros(num_hmat_n, 1);
hmat_hmultv_time_list = zeros(num_hmat_n, 1);
hmat_hmem_list = zeros(num_hmat_n, 1);

htlr_construct_time_list = zeros(num_tlr_n, 1);
htlr_hmultv_time_list = zeros(num_htlr_n, 1);
htlr_hmem_list = zeros(num_htlr_n, 1);

for it_n = 1 : num_hmat_n
    n = hmat_n_list(it_n);
    file_name = "./data/hmat/" + string(n) + "_r_" + string(r) + ".mat";
    load(file_name);
    
    hmat_construct_time_list(it_n) = construct_time;
    hmat_hmultv_time_list(it_n) = hmultv_time;
    hmat_hmem_list(it_n) = hmat_mem;
end

for it_n = 1 : num_htlr_n
    n = htlr_n_list(it_n);
    file_name = "./data/htlr/" + string(n) + "_r_" + string(r) + ".mat";
    load(file_name);
    
    htlr_construct_time_list(it_n) = construct_time;
    htlr_hmultv_time_list(it_n) = hmultv_time;
    htlr_hmem_list(it_n) = htlr_mem;
end

% figure();
% loglog(htlr_N_list, htlr_construct_time_list, ...
%         "LineWidth", 2, ...
%         "Marker", "x", ...
%         "DisplayName", "HTLR");
% hold on;
% loglog(hmat_N_list, hmat_construct_time_list, ...
%         "LineWidth", 2, ...
%         "Marker", "x", ...
%         "DisplayName", "HMAT");
% ref_construct_complexity = N_list .* log2(N_list) .* log2(N_list);
% ref_construct_complexity = ref_construct_complexity / ref_construct_complexity(1) * construct_time_list(1, 1) / 2;
% loglog(N_list(2 : end - 1), ref_construct_complexity(2 : end  -1), ...
%     "LineWidth", 2, ...
%     "LineStyle", "--", ...
%     "DisplayName", "N log^2 N");
% title("construct time");
% xlabel("$N$", "Interpreter", "latex");
% ylabel("$t_{\mathrm{c}}$ (s)", "Interpreter", "latex");
% legend("Location", "southeast");
% set(gca, 'FontSize', 18);
% saveas(gcf, "./figure/RP_construct_time.png", "png");
% saveas(gcf, "./figure/RP_construct_time.eps", "epsc");

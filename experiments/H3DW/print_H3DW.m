clear;
close all;

fprintf("H3DW Plot\n");

hmat_n_list = [32, 64, 128, 256];
num_hmat_n = length(hmat_n_list);
hmat_N_list = hmat_n_list.^3;

htlr_n_list = [32, 64, 128, 256, 512];
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

fprintf("\n\n");
for it_n = 1 : num_htlr_n
    n = htlr_n_list(it_n);
    fprintf("\\(%d^3\\) ", n);
    fprintf("& %d ", r);
    fprintf("& %.1e ", htlr_construct_time_list(it_n));
    if it_n <= num_hmat_n
        fprintf("& \\(%.1f  \\times\\) ", hmat_construct_time_list(it_n) / htlr_construct_time_list(it_n));
    else
        fprintf("& - ");
    end
    fprintf("& %.1e ", htlr_hmem_list(it_n));
    if it_n <= num_hmat_n
        fprintf("& \\(%.1f  \\times\\) ", hmat_hmem_list(it_n) / htlr_hmem_list(it_n));
    else
        fprintf("& - ");
    end
    % if htlr_hmulv_err_list(it_n) ~= 0
    %     fprintf("& %.1e ", htlr_hmulv_err_list(it_n));
    % else
    %     fprintf("& - ");
    % end
    fprintf("& %.1e ", htlr_hmulv_rand_err_list(it_n));
    fprintf("\\\\ \n ");
    fprintf("\\midrule \n");
end
fprintf("\n\n");
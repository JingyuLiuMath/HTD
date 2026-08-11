clear;
close all;

fprintf("H3DW Table\n");

hmat_n_list = [32, 64, 128, 256, 512];
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

fprintf("\n\n");
fprintf("\\begin{table}[htbp]\n");
fprintf("    \\centering\n");
fprintf("    \\begin{tabular}{cccccc}\n");
fprintf("        \\toprule\n");
fprintf("        \\(N\\) & ");
fprintf("& \\(t_{\\construct}\\) (s) ");
fprintf("& \\(m_{\\h}\\) (GB) ");
fprintf("& \\(t_{\\apply}\\) (s) ");
fprintf("& \\(e_{\\apply; \\rand}\\) \\\\ \n");
fprintf("        \\midrule\n");

for it_n = 1 : num_htlr_n
    n = htlr_n_list(it_n);
    it_hmat = find(hmat_n_list == n, 1);

    fprintf("        \\multirow{3}{*}{\\(%d^3\\)} ", n);
    if ~isempty(it_hmat)
        fprintf("& $\\mathcal{H}$-matrix ");
        fprintf("& %.1e ", hmat_construct_time_list(it_hmat));
        fprintf("& %.1e ", hmat_hmem_list(it_hmat));
        fprintf("& %.1e ", hmat_hmultv_time_list(it_hmat));
        fprintf("& %.1e ", hmat_hmulv_rand_err_list(it_hmat));
        fprintf("\\\\ \n");

        fprintf("        & HTD ");
        fprintf("& %.1e ", htlr_construct_time_list(it_n));
        fprintf("& %.1e ", htlr_hmem_list(it_n));
        fprintf("& %.1e ", htlr_hmultv_time_list(it_n));
        fprintf("& %.1e ", htlr_hmulv_rand_err_list(it_n));
        fprintf("\\\\ \n");

        fprintf("        & Ratio ");
        fprintf("& \\(%.1f \\times\\) ", ...
            hmat_construct_time_list(it_hmat) / htlr_construct_time_list(it_n));
        fprintf("& \\(%.1f \\times\\) ", ...
            hmat_hmem_list(it_hmat) / htlr_hmem_list(it_n));
        fprintf("& \\(%.1f \\times\\) ", ...
            hmat_hmultv_time_list(it_hmat) / htlr_hmultv_time_list(it_n));
        fprintf("& - \\\\ \n");
    else
        fprintf("& $\\mathcal{H}$-matrix & - & - & - & - \\\\ \n");
        fprintf("        & HTD ");
        fprintf("& %.1e ", htlr_construct_time_list(it_n));
        fprintf("& %.1e ", htlr_hmem_list(it_n));
        fprintf("& %.1e ", htlr_hmultv_time_list(it_n));
        fprintf("& %.1e ", htlr_hmulv_rand_err_list(it_n));
        fprintf("\\\\ \n");
        fprintf("        & Ratio & - & - & - & - \\\\ \n");
    end
    if it_n < num_htlr_n
        fprintf("        \\midrule\n");
    end
end
fprintf("        \\bottomrule\n");
fprintf("    \\end{tabular}\n");
fprintf("    \\caption{Numerical results of $\\mathcal{H}$-matrices and HTD for the Gaussian kernel\n");
fprintf("    under weak admissibility in \\(3\\)D.} \\label{tab:H3DW}\n");
fprintf("\\end{table}\n\n");

clear;
close all;

exp_H2DWQ_Settings;

fprintf("H2DWQ Print\n");

problem_time_list = nan(num_n, 1);
mmultv_time_list = nan(num_n, 1);
quFuni_err_list = zeros(num_n, num_rho);
uniFqu_err_list = zeros(num_n, num_rho);
intermatrix_time_list = nan(num_n, num_rho);
construct_time_list = nan(num_n, num_rho);
qu_to_uni_time_list = nan(num_n, num_rho);
hmultv_time_list = nan(num_n, num_rho);
uni_to_qu_time_list = nan(num_n, num_rho);
apply_time_list = nan(num_n, num_rho);

for i = 1 : num_n
    n_qu = n_list(i);

    problem_file = "./data/problem/" + string(n_qu) + ".mat";
    problem_data = load(problem_file);
    if isfield(problem_data, "result")
        problem_data = problem_data.result;
    end
    if isfield(problem_data, "problem_time")
        problem_time_list(i) = problem_data.problem_time;
    end
    if isfield(problem_data, "mmultv_time")
        mmultv_time_list(i) = problem_data.mmultv_time;
    end

    for j = 1 : num_rho
        rho = rho_list(j);
        intermatrix_file = "./data/intermatrix/" ...
            + string(n_qu) + "_" + string(rho) + ".mat";
        intermatrix_data = load(intermatrix_file);
        if isfield(intermatrix_data, "result")
            intermatrix_data = intermatrix_data.result;
        end
        quFuni_err_list(i, j) = intermatrix_data.rel_err_quFuni;
        uniFqu_err_list(i, j) = intermatrix_data.rel_err_uniFqu;
        if isfield(intermatrix_data, "intermatrix_time")
            intermatrix_time_list(i, j) = intermatrix_data.intermatrix_time;
        end

        hmv_file = "./data/hmv/" ...
            + string(n_qu) + "_" + string(rho) + ".mat";
        hmv_data = load(hmv_file);
        if isfield(hmv_data, "result")
            hmv_data = hmv_data.result;
        end
        time_fields = ["construct_time", "qu_to_uni_time", ...
            "hmultv_time", "uni_to_qu_time", "apply_time"];
        time_values = nan(1, length(time_fields));
        for k = 1 : length(time_fields)
            if isfield(hmv_data, time_fields(k))
                time_values(k) = hmv_data.(time_fields(k));
            end
        end
        construct_time_list(i, j) = time_values(1);
        qu_to_uni_time_list(i, j) = time_values(2);
        hmultv_time_list(i, j) = time_values(3);
        uni_to_qu_time_list(i, j) = time_values(4);
        apply_time_list(i, j) = time_values(5);
    end
end

fprintf("\n\n");
for i = 1 : num_n
    fprintf("\\(%d\\) & %.1e & %.1e \\\\ \n", ...
        n_list(i), problem_time_list(i), mmultv_time_list(i));
    fprintf("\\midrule \n");
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
        fprintf("& %.1e ", intermatrix_time_list(i, j));
        fprintf("& %.1e ", construct_time_list(i, j));
        fprintf("& %.1e ", qu_to_uni_time_list(i, j));
        fprintf("& %.1e ", hmultv_time_list(i, j));
        fprintf("& %.1e ", uni_to_qu_time_list(i, j));
        fprintf("& %.1e ", apply_time_list(i, j));
        fprintf("\\\\ \n");
    end
    fprintf("\\midrule \n")
end
fprintf("\n\n");

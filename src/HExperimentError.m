function [err, rand_err] = HExperimentError(f, f_ex, f_ex_sampled, rand_rind)

if isempty(f_ex)
    err = NaN;
else
    err = norm(f - f_ex, "fro") / norm(f_ex, "fro");
end

f = f(rand_rind, :);
rand_err = norm(f - f_ex_sampled, "fro") / norm(f_ex_sampled, "fro");

end
function [a_fun, k_fun] = ExperimentKernel(n, dim, kernel_type, kappa)
% ExperimentKernel returns the diagonal and kernel functions.

arguments (Input)
    n (1, 1) double;
    dim (1, 1) double;
    kernel_type (1, 1) string;
    kappa (1, 1) double = 0;
end

arguments (Output)
    a_fun function_handle;
    k_fun function_handle;
end

a_fun = @(xx) zeros(size(xx, 1), 1);
kernel_type = string(kernel_type);

if kernel_type == "SLP"
    if dim == 2
        h = 1 / n;
        sval = SLP2DSelfValue(h);
        k_fun = @(xx, yy) SLP2D(xx, yy, sval);
    elseif dim == 3
        h = 1 / n;
        sval = SLP3DSelfValue(h);
        k_fun = @(xx, yy) SLP3D(xx, yy, sval);
    else
        error("ExperimentKernel:UnsupportedDimension", ...
            "SLP experiments support dim 2 or 3.");
    end
elseif kernel_type == "Helm"
    if kappa <= 0
        error("ExperimentKernel:InvalidWaveNumber", ...
            "kappa must be positive for the Helmholtz kernel.");
    end
    h = 1 / n;
    if dim == 2
        sval = Helm2DSelfValue(h, kappa);
        k_fun = @(xx, yy) Helm2D(xx, yy, kappa, sval);
    elseif dim == 3
        sval = Helm3DSelfValue(h, kappa);
        k_fun = @(xx, yy) Helm3D(xx, yy, kappa, sval);
    else
        error("ExperimentKernel:UnsupportedDimension", ...
            "Helm experiments support dim 2 or 3.");
    end
elseif kernel_type == "Gaussian"
    k_fun = @(xx, yy) Gaussian(xx, yy, sqrt(dim));
else
    error("ExperimentKernel:UnsupportedKernel", ...
        "kernel_type must be SLP, Helm, or Gaussian.");
end

end

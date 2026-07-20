function sval = Helm3DSelfValue(h, kappa)
% Helm3DSelfValue computes the cell-averaged 3D Helmholtz self interaction.

arguments (Input)
    h (1, 1) double {mustBePositive};
    kappa (1, 1) double {mustBePositive};
end

arguments (Output)
    sval (1, 1) double;
end

dist = @(xx1, xx2, xx3) sqrt(xx1.^2 + xx2.^2 + xx3.^2);
s_fun = @(xx1, xx2, xx3) ...
    complex(...
        cos(kappa * dist(xx1, xx2, xx3)), ...
        sin(kappa * dist(xx1, xx2, xx3))) ...
    ./ (4 * pi * dist(xx1, xx2, xx3));

sval = 8 * integral3(s_fun, ...
    0, h / 2, ...
    0, h / 2, ...
    0, h / 2) / h^3;

end

function sval = Helm2DSelfValue(h, kappa)
% Helm2DSelfValue computes the cell-averaged 2D Helmholtz self interaction.

arguments (Input)
    h (1, 1) double {mustBePositive};
    kappa (1, 1) double {mustBePositive};
end

arguments (Output)
    sval (1, 1) double;
end

dist = @(xx1, xx2) sqrt(xx1.^2 + xx2.^2);
s_fun = @(xx1, xx2) ...
    1i / 4 * besselh(0, 1, kappa * dist(xx1, xx2));

sval = 4 * integral2(s_fun, 0, h / 2, 0, h / 2) / h^2;

end

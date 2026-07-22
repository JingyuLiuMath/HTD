function sval = Helm2DTriangleSelfValue(x, v1, v2, v3, kappa)
% Helm2DTriangleSelfValue integrates the 2D Helmholtz kernel over one triangle.

arguments (Input)
    x (1, 2) double;
    v1 (1, 2) double;
    v2 (1, 2) double;
    v3 (1, 2) double;
    kappa (1, 1) double {mustBePositive};
end

arguments (Output)
    sval (1, 1) double;
end

s_fun = @(y1, y2) 1i / 4 * besselh(0, 1, kappa * sqrt(...
    (x(1) - y1).^2 + (x(2) - y2).^2));
sval = TriangularIntegral(s_fun, v1, v2, v3);

end

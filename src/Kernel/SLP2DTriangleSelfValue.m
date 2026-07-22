function sval = SLP2DTriangleSelfValue(x, v1, v2, v3)
% SLP2DTriangleSelfValue integrates the 2D SLP kernel over one triangle.

arguments (Input)
    x (1, 2) double;
    v1 (1, 2) double;
    v2 (1, 2) double;
    v3 (1, 2) double;
end

arguments (Output)
    sval (1, 1) double;
end

s_fun = @(y1, y2) -log(sqrt(...
    (x(1) - y1).^2 + (x(2) - y2).^2)) / (2 * pi);
sval = TriangularIntegral(s_fun, v1, v2, v3);

end

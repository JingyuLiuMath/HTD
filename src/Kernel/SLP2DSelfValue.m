function sval = SLP2DSelfValue(h)
% SLP2DSelfValue computes the cell-averaged 2D SLP self interaction.

arguments (Input)
    h (1, 1) double {mustBePositive};
end

arguments (Output)
    sval (1, 1) double;
end

dist = @(xx1, xx2) sqrt(xx1.^2 + xx2.^2);
s_fun = @(xx1, xx2) -reallog(dist(xx1, xx2)) / (2 * pi);

sval = integral2(s_fun, ...
    -h / 2, h / 2, ...
    -h / 2, h / 2) / h^2;

end

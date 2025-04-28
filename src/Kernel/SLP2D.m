function f = SLP2D(x, y, sval)

arguments (Input)
    x (:, 2) double;
    y (:, 2) double;
    sval (1, 1) double;
end

arguments (Output)
    f (:, :) double;
end

f = -log(pdist2(x, y)) / (2 * pi);
f(f == Inf) = sval;

end
function f = SLP3D(x, y, sval)

arguments (Input)
    x (:, 3) double;
    y (:, 3) double;
    sval (1, 1) double;
end

arguments (Output)
    f (:, :) double;
end

f = 1 ./ pdist2(x, y) / (4 * pi);
f(f == Inf) = sval;

end
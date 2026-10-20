function f = SLP2D(x, y, sval)

arguments (Input)
    x (:, 2) double;
    y (:, 2) double;
    sval (1, 1) double;
end

arguments (Output)
    f (:, :) double;
end

dist_x_y = pdist2(x, y);
f = -log(dist_x_y) / (2 * pi);
f(dist_x_y == 0) = sval;

end
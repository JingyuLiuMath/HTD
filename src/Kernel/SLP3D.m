function f = SLP3D(x, y, sval)

arguments (Input)
    x (:, 3) double;
    y (:, 3) double;
    sval (1, 1) double;
end

arguments (Output)
    f (:, :) double;
end

dist_x_y = pdist2(x, y);
f = 1 ./ dist_x_y  / (4 * pi);
f(dist_x_y == 0) = sval;

end
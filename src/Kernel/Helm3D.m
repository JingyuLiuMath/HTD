function f = Helm3D(x, y, kappa, sval)
% Helm3D evaluates the three-dimensional Helmholtz kernel.

arguments (Input)
    x (:, 3) double;
    y (:, 3) double;
    kappa (1, 1) double;
    sval (1, 1) double;
end

arguments (Output)
    f (:, :) double;
end

dist_x_y = pdist2(x, y);
phase = complex(cos(kappa * dist_x_y), sin(kappa * dist_x_y));
f = phase ./ (4 * pi * dist_x_y);
f(dist_x_y == 0) = sval;

end

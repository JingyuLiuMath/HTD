function f = Helm2D(x, y, kappa, sval)
% Helm2D evaluates the two-dimensional Helmholtz kernel.

arguments (Input)
    x (:, 2) double;
    y (:, 2) double;
    kappa (1, 1) double;
    sval (1, 1) double;
end

arguments (Output)
    f (:, :) double;
end

dist_x_y = pdist2(x, y);
f = 1i / 4 * besselh(0, 1, kappa * dist_x_y);
f(dist_x_y == 0) = sval;

end

function f = OsSLP2D(x, y, kappa, sval)

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
f = -log(dist_x_y) / (2 * pi) ...
    .* complex(cos(2 * pi * kappa * dist_x_y), sin(2 * pi * kappa * dist_x_y));
f(f == Inf) = sval;

end
function f = OsSLP3D(x, y, kappa, sval)

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
f = 1 ./ dist_x_y / (4 * pi) ...
    .* complex(cos(2 * pi * kappa * dist_x_y), sin(2 * pi * kappa * dist_x_y));
f(f == Inf) = sval;

end
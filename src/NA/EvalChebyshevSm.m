function Sm_eval = EvalChebyshevSm(m, a, b, x, y)
% EvalChebyshevSm

% Jingyu Liu, March 25, 2024.

arguments (Input)
    m (1, 1) double;
    a (1, 1) double;
    b (1, 1) double;
    x (:, 1) double;
    y (:, 1) double;
end

arguments (Output)
    Sm_eval (:, :) double;
end

mid = (b + a) / 2;
half_length = (b - a) / 2;

xs = (x - mid) / half_length;
xs(xs <= -1) = -1;
xs(xs >= 1) = 1;
ys = (y - mid) / half_length;
ys(ys <= -1) = -1;
ys(ys >= 1) = 1;

Tkx = cos(acos(xs) * (1 : (m - 1)));
Tky = cos(acos(ys) * (1 : (m - 1)));

Sm_eval = 1 / m + 2 / m * Tkx * Tky';

end
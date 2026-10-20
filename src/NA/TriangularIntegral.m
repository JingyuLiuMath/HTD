function I = TriangularIntegral(f, p1, p2, p3)
% TriangularIntegral Integral on a triangular given by its 3 vertices p1,
% p2 and p3.

% Jingyu Liu, May 22, 2024.

arguments (Input)
    f function_handle;  % f = f(x, y)
    p1 (1, 2) double;
    p2 (1, 2) double;
    p3 (1, 2) double;
end

arguments (Output)
    I (1, 1) double;
end

x1 = p1(1);
y1 = p1(2);

x2 = p2(1);
y2 = p2(2);

x3 = p3(1);
y3 = p3(2);

jg = abs((x2 - x1) * (y3 - y1) - (x3 - x1) * (y2 - y1));
ftilde = @(u, v) f(x1 + u * (x2 - x1) + v * (x3 - x1), ...
    y1 + u * (y2 - y1) + v * (y3 - y1));

v_max = @(uu) 1 - uu;
I = jg * integral2(ftilde, 0, 1, 0, v_max);

end
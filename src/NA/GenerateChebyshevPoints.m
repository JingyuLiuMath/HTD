function x = GenerateChebyshevPoints(m, a, b)
% GenerateChebyshevPoints Generate Chebyshev points on [a, b].

% Jingyu Liu, February 22, 2024.

arguments (Input)
    m (1, 1) double;
    a (1, 1) double = -1;
    b (1, 1) double = 1;
end

arguments (Output)
    x (:, 1) double;
end

% Generate Chebyshev points on [-1, 1]
theta = (2 * (1 : m) - 1)' * pi / 2 / m;
x_chebyshev = cos(theta);

% Scale and shift Chebyshev points to [a, b]
x = ((b - a) * x_chebyshev + (b + a)) / 2;

end
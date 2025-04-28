function x = TensorProduct2D(x1, x2)

arguments (Input)
    x1 (:, 1) double;
    x2 (:, 1) double;
end

arguments (Output)
    x (:, 2) double;
end

[X1, X2] = ndgrid(x1, x2);
x = [X1(:), X2(:)];

end
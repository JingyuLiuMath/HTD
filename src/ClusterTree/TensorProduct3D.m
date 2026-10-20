function x = TensorProduct3D(x1, x2, x3)

arguments (Input)
    x1 (:, 1) double;
    x2 (:, 1) double;
    x3 (:, 1) double;
end

arguments (Output)
    x (:, 3) double;
end

[X1, X2, X3] = ndgrid(x1, x2, x3);
x = [X1(:), X2(:), X3(:)];

end
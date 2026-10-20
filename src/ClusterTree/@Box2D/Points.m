function x = Points(B)

arguments (Input)
    B Box2D;
end

arguments (Output)
    x (:, 2) double
end

x = TensorProduct2D(B.I1_.Points(), B.I2_.Points());

end
function x = x2Points(B)

arguments (Input)
    B Box2D;
end

arguments (Output)
    x (:, 1) double
end

x = B.I2_.Points();

end
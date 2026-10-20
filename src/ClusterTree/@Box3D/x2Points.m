function x = x2Points(B)

arguments (Input)
    B Box3D;
end

arguments (Output)
    x (:, 1) double
end

x = B.I2_.Points();

end
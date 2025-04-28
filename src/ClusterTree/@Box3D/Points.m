function x = Points(B)

arguments (Input)
    B Box3D;
end

arguments (Output)
    x (:, 3) double
end

x = TensorProduct3D(B.I1_.Points(), B.I2_.Points(), B.I3_.Points());

end
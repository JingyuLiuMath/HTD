function x = x3Points(B)

arguments (Input)
    B Box3D;
end

arguments (Output)
    x (:, 1) double
end

x = B.I3_.Points();

end
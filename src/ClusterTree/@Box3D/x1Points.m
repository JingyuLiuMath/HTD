function x = x1Points(B)

arguments (Input)
    B Box3D;
end

arguments (Output)
    x (:, 1) double
end

x = B.I1_.Points();

end
function x = x1Points(B)

arguments (Input)
    B Box2D;
end

arguments (Output)
    x (:, 1) double
end

x = B.I1_.Points();

end
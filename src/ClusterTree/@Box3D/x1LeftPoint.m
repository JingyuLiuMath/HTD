function xl = x1LeftPoint(B)

arguments (Input)
    B Box3D;
end

arguments (Output)
    xl (1, 1) double;
end

xl = B.I1_.LeftPoint();

end
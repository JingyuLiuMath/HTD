function xl = x3LeftPoint(B)

arguments (Input)
    B Box3D;
end

arguments (Output)
    xl (1, 1) double;
end

xl = B.I3_.LeftPoint();

end
function xl = x2LeftPoint(B)

arguments (Input)
    B Box2D;
end

arguments (Output)
    xl (1, 1) double;
end

xl = B.I2_.LeftPoint();

end
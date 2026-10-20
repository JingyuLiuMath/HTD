function a = Diameter(B)

arguments (Input)
    B Box2D;
end

arguments (Output)
    a (1, 1) double;
end

a = sqrt(B.I1_.Diameter()^2 + B.I2_.Diameter()^2);

end
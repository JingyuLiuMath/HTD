function d = Distance(B1, B2)

arguments (Input)
    B1 Box2D;
    B2 Box2D;
end

arguments (Output)
    d (1, 1) double;
end

d = sqrt(Distance(B1.I1_, B2.I1_)^2 ...
    + Distance(B1.I2_, B2.I2_)^2);

end
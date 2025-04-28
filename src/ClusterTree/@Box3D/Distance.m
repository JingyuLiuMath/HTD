function d = Distance(B1, B2)

arguments (Input)
    B1 Box3D;
    B2 Box3D;
end

arguments (Output)
    d (1, 1) double;
end

d = sqrt(Distance(B1.I1_, B2.I1_)^2 ...
    + Distance(B1.I2_, B2.I2_)^2 ...
    + Distance(B1.I3_, B2.I3_)^2);

end
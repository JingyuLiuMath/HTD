function flag = eq(B1, B2)

arguments(Input)
    B1 Box3D;
    B2 Box3D;
end

arguments (Output)
    flag (1, 1) double;
end

flag = (B1.I1_ == B2.I1_) && (B1.I2_ == B2.I2_) && (B1.I3_ == B2.I3_);

end
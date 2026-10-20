function flag = eq(B1, B2)

arguments(Input)
    B1 Box2D;
    B2 Box2D;
end

arguments (Output)
    flag (1, 1) double;
end

flag = (B1.I1_ == B2.I1_) && (B1.I2_ == B2.I2_);

end
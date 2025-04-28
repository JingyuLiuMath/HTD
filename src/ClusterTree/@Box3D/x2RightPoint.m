function xr = x2RightPoint(B)

arguments (Input)
    B Box3D;
end

arguments (Output)
    xr (1, 1) double;
end

xr = B.I2_.RightPoint();

end
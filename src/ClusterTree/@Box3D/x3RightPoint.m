function xr = x3RightPoint(B)

arguments (Input)
    B Box3D;
end

arguments (Output)
    xr (1, 1) double;
end

xr = B.I3_.RightPoint();

end
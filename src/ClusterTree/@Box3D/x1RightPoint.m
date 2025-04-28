function xr = x1RightPoint(B)

arguments (Input)
    B Box3D;
end

arguments (Output)
    xr (1, 1) double;
end

xr = B.I1_.RightPoint();

end
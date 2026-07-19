function B = ExperimentBox(n, dim)
% ExperimentBox builds the tensor-product box used by experiments.

arguments (Input)
    n (1, 1) double;
    dim (1, 1) double;
end

arguments (Output)
    B;
end

I = Interval(n);
if dim == 2
    B = Box2D(I, I);
elseif dim == 3
    B = Box3D(I, I, I);
else
    error("ExperimentBox:UnsupportedDimension", ...
        "dim must be 2 or 3.");
end

end

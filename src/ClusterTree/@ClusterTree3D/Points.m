function x = Points(T)

arguments (Input)
    T ClusterTree3D;
end

arguments (Output)
    x (:, 3) double
end

x = T.B_.Points();

end
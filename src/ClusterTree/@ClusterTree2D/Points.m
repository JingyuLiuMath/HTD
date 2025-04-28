function x = Points(T)

arguments (Input)
    T ClusterTree2D;
end

arguments (Output)
    x (:, 2) double
end

x = T.B_.Points();

end
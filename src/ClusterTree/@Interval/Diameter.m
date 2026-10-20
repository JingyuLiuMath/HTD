function a = Diameter(I)

arguments (Input)
    I Interval;
end

arguments (Output)
    a (1, 1) double;
end

a = I.size_ / I.global_size_;

end
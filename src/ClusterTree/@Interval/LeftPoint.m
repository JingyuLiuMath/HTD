function xl = LeftPoint(I)

arguments (Input)
    I Interval;
end

arguments (Output)
    xl (1, 1) double;
end

h = 1 / I.global_size_;
xl = h / 2 + (I.left_ind_ - 1) * h;

end
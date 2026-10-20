function d = Distance(I1, I2)

arguments (Input)
    I1 Interval;
    I2 Interval;
end

arguments (Output)
    d (1, 1) double;
end

c1 = (I1.left_ind_ + I1.right_ind_) / 2;
h1 = I1.size_ / 2;

c2 = (I2.left_ind_ + I2.right_ind_) / 2;
h2 = I2.size_ / 2;

d = max(abs(c1 - c2) - (h1 + h2), 0) / I1.global_size_;

end
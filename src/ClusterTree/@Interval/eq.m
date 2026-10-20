function flag = eq(I1, I2)

arguments (Input)
    I1 Interval;
    I2 Interval;
end

arguments (Output)
    flag (1, 1) double;
end

flag = (I1.global_size_ == I2.global_size_) ...
    && (I1.left_ind_ == I2.left_ind_) ...
    && (I1.right_ind_ == I2.right_ind_);

end
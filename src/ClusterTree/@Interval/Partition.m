function [I1, I2] = Partition(I)

arguments (Input)
    I Interval;
end

arguments (Output)
    I1 Interval;
    I2 Interval;
end

c1_size = floor(I.size_ / 2);
I1 = Interval(I.global_size_, ...
    I.left_ind_, I.left_ind_ + c1_size - 1);
I2 = Interval(I.global_size_, ...
    I.left_ind_ + c1_size, I.right_ind_);

end
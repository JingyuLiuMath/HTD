function x = Points(I)

arguments (Input)
    I Interval;
end

arguments (Output)
    x (:, 1);
end

h = 1 / I.global_size_;
x = h / 2 + ((I.left_ind_ : I.right_ind_)' - 1) * h;

end
function xr = RightPoint(I)

arguments (Input)
    I Interval;
end

arguments (Output)
    xr (1, 1) double;
end

h = 1 / I.global_size_;
xr = h / 2 + (I.right_ind_ - 1) * h;

end
function ind = GlobalInd(B)

arguments (Input)
    B Box3D;
end

arguments (Output)
    ind (:, 1);
end

I = TensorProduct3D(...
    B.I1_.left_ind_ : B.I1_.right_ind_, ...
    B.I2_.left_ind_ : B.I2_.right_ind_, ...
    B.I3_.left_ind_ : B.I3_.right_ind_);
ind = sub2ind([B.I1_.global_size_, B.I2_.global_size_, B.I3_.global_size_], ...
    I(:, 1), ...
    I(:, 2), ...
    I(:, 3));

end
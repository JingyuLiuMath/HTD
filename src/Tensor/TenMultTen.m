function C = TenMultTen(A, mult_dim_A, B, mult_dim_B)
% TenMultTen

% Jingyu Liu, May 9, 2024.

arguments (Input)
    A double;
    mult_dim_A (1, :) double;
    B double;
    mult_dim_B (1, :) double;
end

arguments (Output)
    C double;
end

C = tensorprod(A, B, mult_dim_A, mult_dim_B);

end
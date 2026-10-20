function [U1, U2, G, V1, V2] = TLR_SVD2D(Br, Bc, k_fun, r)

arguments (Input)
    Br Box2D;
    Bc Box2D;
    k_fun function_handle;
    r (1, 1) double;
end

arguments (Output)
    U1 (:, :) double;
    U2 (:, :) double;
    G (:, :, :, :) double;
    V1 (:, :) double;
    V2 (:, :) double;
end

[G, U, ~] = STHOSVD(...
    reshape(k_fun(Br.Points(), Bc.Points()), ...
    [...
    Br.I1_.size_, ...
    Br.I2_.size_, ...
    Bc.I1_.size_, ...
    Bc.I2_.size_]), ...
    r);
U1 = U{1};
U2 = U{2};
V1 = U{3};
V2 = U{4};

end
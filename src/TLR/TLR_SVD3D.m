function [U1, U2, U3, G, V1, V2, V3] = TLR_SVD3D(Br, Bc, k_fun, r)

% Jingyu Liu, October 24, 2024.

arguments (Input)
    Br Box3D;
    Bc Box3D;
    k_fun function_handle;
    r (1, 1) double;
end

arguments (Output)
    U1 (:, :) double;
    U2 (:, :) double;
    U3 (:, :) double;
    G (:, :, :, :, :, :) double;
    V1 (:, :) double;
    V2 (:, :) double;
    V3 (:, :) double;
end

[G, U, ~] = STHOSVD(...
    reshape(k_fun(Br.Points(), Bc.Points()), ...
    [...
    Br.I1_.size_, ...
    Br.I2_.size_, ...
    Br.I3_.size_, ...
    Bc.I1_.size_, ...
    Bc.I2_.size_, ...
    Bc.I3_.size_]), ...
    r);
U1 = U{1};
U2 = U{2};
U3 = U{3};
V1 = U{4};
V2 = U{5};
V3 = U{6};

end
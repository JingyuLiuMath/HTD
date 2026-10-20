function Construct_IE(H, T_row, T_col, ad, a_fun, k_fun, r, tol)

arguments (Input)
    H HMAT2D;
    T_row ClusterTree2D;
    T_col ClusterTree2D;
    ad string;
    a_fun function_handle;
    k_fun function_handle;
    r (1, 1) double;  % rank in each direction.
    tol (1, 1) double;
end

if Admissible2D(T_row.B_, T_col.B_, ad)
    H.leaf_ = 1;
    H.ad_ = 1;

    r = min([r, ...
        T_row.B_.I1_.size_, T_row.B_.I2_.size_, ...
        T_col.B_.I1_.size_, T_col.B_.I2_.size_]);

    N = T_row.B_.global_size_;
    [U, G, V] = LR_Chebyshev2D(...
        T_row.B_, T_col.B_, ...
        k_fun, r);
    H.G_ = G / N;
    H.U_ = U(T_row.q_, :);
    H.V_ = V(T_col.q_, :);

    % Recompression.
    [UG, S, VG] = MySVDTrunc(H.G_, tol);
    H.U_ = H.U_ * UG;
    H.G_ = S;
    H.V_ = H.V_ * VG;
elseif T_row.leaf_ == 1 || T_col.leaf_ == 1
    H.leaf_ = 1;
    H.ad_ = 0;

    N = T_row.B_.global_size_;
    if T_row.B_ == T_col.B_
        D = diag(a_fun(T_col.B_.Points())) ...
            + k_fun(T_row.B_.Points(), T_col.B_.Points()) / N;
    else
        D = k_fun(T_row.B_.Points(), T_col.B_.Points()) / N;
    end
    H.D_ = D(T_row.q_, T_col.q_);
else
    H.leaf_ = 0;
    H.ch_ = cell(2, 2, 2, 2);
    for rit2 = 1 : 2
        for rit1 = 1 : 2
            for cit2 = 1 : 2
                for cit1 = 1 : 2
                    H.ch_{rit1, rit2, cit1, cit2} = HMAT2D(...
                        T_row.ch_{rit1, rit2}.B_.size_, ...
                        T_col.ch_{cit1, cit2}.B_.size_, ...
                        H.level_ + 1);
                    H.ch_{rit1, rit2, cit1, cit2}.Construct_IE(...
                        T_row.ch_{rit1, rit2}, T_col.ch_{cit1, cit2}, ...
                        ad, a_fun, k_fun, r, tol);
                end
            end
        end
    end
end

end
function Construct_IE(H, T_row, T_col, ad, a_fun, k_fun, r)

arguments (Input)
    H HMAT3D;
    T_row ClusterTree3D;
    T_col ClusterTree3D;
    ad string;
    a_fun function_handle;
    k_fun function_handle;
    r (1, 1) double;  % rank in each direction.
end

if Admissible3D(T_row.B_, T_col.B_, ad)
    H.leaf_ = 1;
    H.ad_ = 1;

    r = min([r, ...
        T_row.B_.I1_.size_, T_row.B_.I2_.size_, T_row.B_.I3_.size_, ...
        T_col.B_.I1_.size_, T_col.B_.I2_.size_, T_col.B_.I3_.size_]);

    N = T_row.B_.global_size_;
    [U, G, V] = LR_Chebyshev3D(...
        T_row.B_, T_col.B_, ...
        k_fun, r);
    H.G_ = G / N;
    H.U_ = U(T_row.q_, :);
    H.V_ = V(T_col.q_, :);
elseif T_row.leaf_ == 1 || T_col.leaf_ == 1
    H.leaf_ = 1;
    H.ad_ = 0;

    N = T_row.B_.global_size_;
    if T_row.B_ == T_col.B_
        D = diag(a_fun(T_col.Points())) ...
            + k_fun(T_row.Points(), T_col.Points()) / N;
    else
        D = k_fun(T_row.Points(), T_col.Points()) / N;
    end
    H.D_ = D(T_row.q_, T_col.q_);
else
    H.leaf_ = 0;
    H.ch_ = cell(2, 2, 2, 2, 2, 2);
    for rit3 = 1 : 2
        for rit2 = 1 : 2
            for rit1 = 1 : 2
                for cit3 = 1 : 2
                    for cit2 = 1 : 2
                        for cit1 = 1 : 2
                            H.ch_{rit1, rit2, rit3, cit1, cit2, cit3} = HMAT3D(...
                                T_row.ch_{rit1, rit2, rit3}.B_.size_, ...
                                T_col.ch_{cit1, cit2, cit3}.B_.size_, ...
                                H.level_ + 1);
                            H.ch_{rit1, rit2, rit3, cit1, cit2, cit3}.Construct_IE(...
                                T_row.ch_{rit1, rit2, rit3}, T_col.ch_{cit1, cit2, cit3}, ...
                                ad, a_fun, k_fun, r);
                        end
                    end
                end
            end
        end
    end
end

end
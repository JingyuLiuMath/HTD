function Construct_IE(H, T_row, T_col, ad, a_fun, k_fun, r)

arguments (Input)
    H HTLR2D;
    T_row ClusterTree2D;
    T_col ClusterTree2D;
    ad string;
    a_fun function_handle;
    k_fun function_handle;
    r (1, 1) double;  % rank in each direction.
end

if Admissible2D(T_row.B_, T_col.B_, ad)
    H.leaf_ = 1;
    H.ad_ = 1;

    r = min([r, ...
        T_row.B_.I1_.size_, T_row.B_.I2_.size_, ...
        T_col.B_.I1_.size_, T_col.B_.I2_.size_]);

    N = T_row.B_.global_size_;
    [H.U1_, H.U2_, G, H.V1_, H.V2_] = TLR_Chebyshev2D(...
        T_row.B_, T_col.B_, ...
        k_fun, r);
    H.G_ = G / N;
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
    H.D_ = reshape(D, [H.r1size_, H.r2size_, H.c1size_, H.c2size_]);
else
    H.leaf_ = 0;
    H.ch_ = cell(2, 2, 2, 2);
    for rit2 = 1 : 2
        for rit1 = 1 : 2
            for cit2 = 1 : 2
                for cit1 = 1 : 2
                    H.ch_{rit1, rit2, cit1, cit2} = HTLR2D(...
                        T_row.ch_{rit1, rit2}.B_.I1_.size_, ...
                        T_row.ch_{rit1, rit2}.B_.I2_.size_, ...
                        T_col.ch_{cit1, cit2}.B_.I1_.size_, ...
                        T_col.ch_{cit1, cit2}.B_.I2_.size_, ...
                        H.level_ + 1);
                    H.ch_{rit1, rit2, cit1, cit2}.Construct_IE(...
                        T_row.ch_{rit1, rit2}, T_col.ch_{cit1, cit2}, ...
                        ad, a_fun, k_fun, r);
                end
            end
        end
    end
end

end
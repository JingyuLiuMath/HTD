function f = HMultV(H, u, f)

arguments (Input)
    H HTLR3D;
    u (:, :, :, :) double;
    f (:, :, :, :) double = zeros(H.r1size_, H.r2size_, H.r3size_, size(u, 4));
end

arguments (Output)
    f (:, :, :, :) double;
end

% Validate the public inputs only once.  The recursive kernel below avoids
% repeating arguments-block validation at every node of the block tree.
f = HMultVRecursive(H, u, f);

end

function f = HMultVRecursive(H, u, f)

if H.leaf_ == 0
    r3off = 0;
    for rit3 = 1 : 2
        r3size = H.ch_{1, 1, rit3, 1, 1, 1}.r3size_;
        r3ind = (r3off + 1) : (r3off + r3size);
        r2off = 0;
        for rit2 = 1 : 2
            r2size = H.ch_{1, rit2, 1, 1, 1, 1}.r2size_;
            r2ind = (r2off + 1) : (r2off + r2size);
            r1off = 0;
            for rit1 = 1 : 2
                r1size = H.ch_{rit1, 1, 1, 1, 1, 1}.r1size_;
                r1ind = (r1off + 1) : (r1off + r1size);

                % Extract an output row block once, accumulate the
                % contributions from all eight column children, and write
                % the completed block back once.
                f_curr = f(r1ind, r2ind, r3ind, :);
                c3off = 0;
                for cit3 = 1 : 2
                    c3size = H.ch_{1, 1, 1, 1, 1, cit3}.c3size_;
                    c3ind = (c3off + 1) : (c3off + c3size);
                    c2off = 0;
                    for cit2 = 1 : 2
                        c2size = H.ch_{1, 1, 1, 1, cit2, 1}.c2size_;
                        c2ind = (c2off + 1) : (c2off + c2size);
                        c1off = 0;
                        for cit1 = 1 : 2
                            child = H.ch_{...
                                rit1, rit2, rit3, cit1, cit2, cit3};
                            c1size = child.c1size_;
                            c1ind = (c1off + 1) : (c1off + c1size);
                            f_curr = HMultVRecursive(...
                                child, u(c1ind, c2ind, c3ind, :), f_curr);
                            c1off = c1off + c1size;
                        end
                        c2off = c2off + c2size;
                    end
                    c3off = c3off + c3size;
                end
                f(r1ind, r2ind, r3ind, :) = f_curr;
                r1off = r1off + r1size;
            end
            r2off = r2off + r2size;
        end
        r3off = r3off + r3size;
    end
elseif H.ad_ == 0
    % View the dense tensor block as an ordinary matrix.  Reshape preserves
    % the tensor ordering and exposes one BLAS multiplication for all
    % right-hand sides.
    num_rhs = size(u, 4);
    D_mat = reshape(H.D_, ...
        H.r1size_ * H.r2size_ * H.r3size_, ...
        H.c1size_ * H.c2size_ * H.c3size_);
    u_mat = reshape(u, ...
        H.c1size_ * H.c2size_ * H.c3size_, num_rhs);
    f = f + reshape(D_mat * u_mat, ...
        H.r1size_, H.r2size_, H.r3size_, num_rhs);
else
    % Apply V1 and V2 along the first two physical modes.  Tucker
    % reconstruction uses the factors without conjugation, so contractions
    % use the nonconjugate transpose (V1_.') for complex-valued factors.
    % The remaining dimensions and right-hand sides are treated as pages.
    col_rank1 = size(H.G_, 4);
    col_rank2 = size(H.G_, 5);
    col_rank3 = size(H.G_, 6);
    num_rhs = size(u, 4);
    u_coeff = pagemtimes(H.V1_.', u);
    u_coeff = pagemtimes(u_coeff, H.V2_);

    % Bring the third physical mode into the matrix dimension, then apply
    % V3 to every right-hand side page.
    u_coeff = reshape(u_coeff, ...
        col_rank1 * col_rank2, H.c3size_, num_rhs);
    u_coeff = pagemtimes(u_coeff, H.V3_);

    % Contract the matricized six-dimensional core with all transformed
    % right-hand sides in one matrix multiplication.
    row_rank1 = size(H.G_, 1);
    row_rank2 = size(H.G_, 2);
    row_rank3 = size(H.G_, 3);
    G_mat = reshape(H.G_, ...
        row_rank1 * row_rank2 * row_rank3, ...
        col_rank1 * col_rank2 * col_rank3);
    core_values = G_mat * reshape(u_coeff, ...
        col_rank1 * col_rank2 * col_rank3, num_rhs);
    core_values = reshape(core_values, ...
        row_rank1, row_rank2, row_rank3, num_rhs);

    % Apply U1 and U2 along the first two row modes without conjugation.
    f_curr = pagemtimes(H.U1_, core_values);
    f_curr = pagemtimes(f_curr, H.U2_.');

    % Apply U3 without conjugation and restore the physical shape.
    f_curr = reshape(f_curr, ...
        H.r1size_ * H.r2size_, row_rank3, num_rhs);
    f_curr = pagemtimes(f_curr, H.U3_.');
    f = f + reshape(f_curr, ...
        H.r1size_, H.r2size_, H.r3size_, num_rhs);
end

end

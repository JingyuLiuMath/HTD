function f = HMultV(H, u, f)

arguments (Input)
    H HTLR2D;
    u (:, :, :) double;
    f (:, :, :) double = zeros(H.r1size_, H.r2size_, size(u, 3));
end

arguments (Output)
    f (:, :, :) double;
end

% Validate the public inputs only once.  The recursive kernel below avoids
% repeating arguments-block validation at every node of the block tree.
f = HMultVRecursive(H, u, f);

end

function f = HMultVRecursive(H, u, f)

if H.leaf_ == 0
    r2off = 0;
    for rit2 = 1 : 2
        r2size = H.ch_{1, rit2, 1, 1}.r2size_;
        r2ind = (r2off + 1) : (r2off + r2size);
        r1off = 0;
        for rit1 = 1 : 2
            r1size = H.ch_{rit1, 1, 1, 1}.r1size_;
            r1ind = (r1off + 1) : (r1off + r1size);

            % Extract an output row block once, accumulate the contributions
            % from all four column children, and write the block back once.
            f_curr = f(r1ind, r2ind, :);
            c2off = 0;
            for cit2 = 1 : 2
                c2size = H.ch_{1, 1, 1, cit2}.c2size_;
                c2ind = (c2off + 1) : (c2off + c2size);
                c1off = 0;
                for cit1 = 1 : 2
                    child = H.ch_{rit1, rit2, cit1, cit2};
                    c1size = child.c1size_;
                    c1ind = (c1off + 1) : (c1off + c1size);
                    f_curr = HMultVRecursive(...
                        child, u(c1ind, c2ind, :), f_curr);
                    c1off = c1off + c1size;
                end
                c2off = c2off + c2size;
            end
            f(r1ind, r2ind, :) = f_curr;
            r1off = r1off + r1size;
        end
        r2off = r2off + r2size;
    end
elseif H.ad_ == 0
    % View the dense tensor block as an ordinary matrix.  Reshape does not
    % change the tensor ordering, so the contraction is one BLAS matrix
    % multiplication for all right-hand sides.
    num_rhs = size(u, 3);
    D_mat = reshape(H.D_, ...
        H.r1size_ * H.r2size_, H.c1size_ * H.c2size_);
    u_mat = reshape(u, H.c1size_ * H.c2size_, num_rhs);
    f = f + reshape(D_mat * u_mat, ...
        H.r1size_, H.r2size_, num_rhs);
else
    % Apply the column Tucker factors mode by mode.  Tucker reconstruction
    % uses the factors without conjugation, so contractions use the
    % nonconjugate transpose (V1_.') for complex-valued factors.  The first
    % two physical modes are matrix dimensions of pagemtimes; all
    % right-hand sides are processed as pages.
    col_rank1 = size(H.G_, 3);
    col_rank2 = size(H.G_, 4);
    num_rhs = size(u, 3);
    u_coeff = pagemtimes(H.V1_.', u);
    u_coeff = pagemtimes(u_coeff, H.V2_);

    % Contract the matricized core with all transformed right-hand sides.
    row_rank1 = size(H.G_, 1);
    row_rank2 = size(H.G_, 2);
    G_mat = reshape(H.G_, ...
        row_rank1 * row_rank2, col_rank1 * col_rank2);
    core_values = G_mat * reshape(u_coeff, ...
        col_rank1 * col_rank2, num_rhs);
    core_values = reshape(core_values, ...
        row_rank1, row_rank2, num_rhs);

    % Apply the row Tucker factors, again without conjugating U2_, and
    % restore the physical tensor shape.
    f_curr = pagemtimes(H.U1_, core_values);
    f_curr = pagemtimes(f_curr, H.U2_.');
    f = f + reshape(f_curr, H.r1size_, H.r2size_, num_rhs);
end

end

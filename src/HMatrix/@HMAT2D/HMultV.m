function f = HMultV(H, u, f)

arguments (Input)
    H HMAT2D;
    u (:, :) double;
    f (:, :) double = zeros(H.rsize_, size(u, 2));
end

arguments (Output)
    f (:, :) double;
end

if H.leaf_ == 0
    roff = 0;
    for rit2 = 1 : 2
        for rit1 = 1 : 2
            coff = 0;
            rsize = H.ch_{rit1, rit2, 1, 1}.rsize_;
            for cit2 = 1 : 2
                for cit1 = 1 : 2
                    csize = H.ch_{1, 1, cit1, cit2}.csize_;
                    f((roff + 1) : (roff + rsize), :) = HMultV(...
                        H.ch_{rit1, rit2, cit1, cit2}, ...
                        u((coff + 1) : (coff + csize), :), ...
                        f((roff + 1) : (roff + rsize), :));
                    coff = coff + csize;
                end
            end
            roff = roff + rsize;
        end
    end
else
    if H.ad_ == 0
        f = f + H.D_ * u;
    else
        f = f + H.U_ * (H.G_ * (H.V_' * u));
    end
end

end
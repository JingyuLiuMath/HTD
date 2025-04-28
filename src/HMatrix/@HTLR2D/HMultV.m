function f = HMultV(H, u, f)

arguments (Input)
    H HTLR2D;
    u (:, :, :) double;
    f (:, :, :) double = zeros(H.r1size_, H.r2size_, size(u, 3));
end

arguments (Output)
    f (:, :, :) double;
end

if H.leaf_ == 0
    r2off = 0;
    for rit2 = 1 : 2
        r2size = H.ch_{1, rit2, 1, 1}.r2size_;
        r1off = 0;
        for rit1 = 1 : 2
            r1size = H.ch_{rit1, 1, 1, 1}.r1size_;
            c2off = 0;
            for cit2 = 1 : 2
                c2size = H.ch_{1, 1, 1, cit2}.c2size_;
                c1off = 0;
                for cit1 = 1 : 2
                    c1size = H.ch_{1, 1, cit1, 1}.c1size_;
                    f((r1off + 1) : (r1off + r1size), (r2off + 1) : (r2off + r2size), :) = HMultV(...
                        H.ch_{rit1, rit2, cit1, cit2}, ...
                        u((c1off + 1) : (c1off + c1size), (c2off + 1) : (c2off + c2size), :), ...
                        f((r1off + 1) : (r1off + r1size), (r2off + 1) : (r2off + r2size), :));
                    c1off = c1off + c1size;
                end
                c2off = c2off + c2size;
            end
            r1off = r1off + r1size;
        end
        r2off = r2off + r2size;
    end
else
    if H.ad_ == 0
        f = f + tensorprod(H.D_, u, [3, 4], [1, 2]);
    else
        f = f + tensorprod(H.U1_, ...
            tensorprod(H.U2_, ...
            tensorprod(H.G_, ...
            tensorprod(H.V1_, ...
            tensorprod(H.V2_, ...
            u, 1, 2), ...
            1, 2), ...
            [3, 4], [1, 2]), ...
            2, 2), ...
            2, 2);
    end
end

end
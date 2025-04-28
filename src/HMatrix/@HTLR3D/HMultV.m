function f = HMultV(H, u, f)

arguments (Input)
    H HTLR3D;
    u (:, :, :, :) double;
    f (:, :, :, :) double = zeros(H.r1size_, H.r2size_, H.r3size_, size(u, 4));
end

arguments (Output)
    f (:, :, :, :) double;
end

if H.leaf_ == 0
    r3off = 0;
    for rit3 = 1 : 2
        r3size = H.ch_{1, 1, rit3, 1, 1, 1}.r3size_;
        r2off = 0;
        for rit2 = 1 : 2
            r2size = H.ch_{1, rit2, 1, 1, 1, 1}.r2size_;
            r1off = 0;
            for rit1 = 1 : 2
                r1size = H.ch_{rit1, 1, 1, 1, 1, 1}.r1size_;
                c3off = 0;
                for cit3 = 1 : 2
                    c3size = H.ch_{1, 1, 1, 1, 1, cit3}.c3size_;
                    c2off = 0;
                    for cit2 = 1 : 2
                        c2size = H.ch_{1, 1, 1, 1, cit2, 1}.c2size_;
                        c1off = 0;
                        for cit1 = 1 : 2
                            c1size = H.ch_{1, 1, cit1, 1}.c1size_;
                            f((r1off + 1) : (r1off + r1size), ...
                                (r2off + 1) : (r2off + r2size), ...
                                (r3off + 1) : (r3off + r3size), :) = HMultV(...
                                H.ch_{rit1, rit2, rit3, cit1, cit2, cit3}, ...
                                u((c1off + 1) : (c1off + c1size), ...
                                (c2off + 1) : (c2off + c2size), ...
                                (c3off + 1) : (c3off + c3size), :), ...
                                f((r1off + 1) : (r1off + r1size), ...
                                (r2off + 1) : (r2off + r2size), ...
                                (r3off + 1) : (r3off + r3size), :));
                            c1off = c1off + c1size;
                        end
                        c2off = c2off + c2size;
                    end
                    c3off = c3off + c3size;
                end
                r1off = r1off + r1size;
            end
            r2off = r2off + r2size;
        end
        r3off = r3off + r3size;
    end
else
    if H.ad_ == 0
        f = f + tensorprod(H.D_, u, [4, 5, 6], [1, 2, 3]);
    else
        f = f +tensorprod(H.U1_, ...
            tensorprod(H.U2_, ...
            tensorprod(H.U3_, ...
            tensorprod(H.G_, ...
            tensorprod(H.V1_, ...
            tensorprod(H.V2_, ...
            tensorprod(H.V3_, ...
            u, 1, 3), ...
            1, 3), ...
            1, 3), ...
            [4, 5, 6], [1, 2, 3]), ...
            2, 3), ...
            2, 3), ...
            2, 3);
    end
end

end
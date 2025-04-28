function mem = Storage(H)

arguments (Input)
    H HTLR3D;
end

arguments (Output)
    mem (:, :) double;
end

if H.leaf_ == 0
    mem = 0;
    for rit3 = 1 : 2
        for rit2 = 1 : 2
            for cit3 = 1 : 2
                for rit1 = 1 : 2
                    for cit2 = 1 : 2
                        for cit1 = 1 : 2
                            mem = mem + H.ch_{rit1, rit2, rit3, cit1, cit2, cit3}.Storage();
                        end
                    end
                end
            end
        end
    end
else
    if H.ad_ == 0
        mem = numel(H.D_);
    else
        mem = numel(H.U1_) + numel(H.U2_) + numel(H.U3_) ...
            + numel(H.G_) ...
            + numel(H.V1_) + numel(H.V2_) + numel(H.V3_);
    end
end

end
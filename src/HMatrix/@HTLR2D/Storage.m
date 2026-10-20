function mem = Storage(H)

arguments (Input)
    H HTLR2D;
end

arguments (Output)
    mem (:, :) double;
end

if H.leaf_ == 0
    mem = 0;
    for rit2 = 1 : 2
        for rit1 = 1 : 2
            for cit2 = 1 : 2
                for cit1 = 1 : 2
                    mem = mem + H.ch_{rit1, rit2, cit1, cit2}.Storage();
                end
            end
        end
    end
else
    if H.ad_ == 0
        mem = byte_size(H.D_);
    else
        mem = byte_size(H.U1_) + byte_size(H.U2_) ...
            + byte_size(H.G_) ...
            + byte_size(H.V1_) + byte_size(H.V2_);
    end
end

end
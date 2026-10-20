function PlotHMat(H, x, y, hx, hy)
% PlotHMat

arguments (Input)
    H HMAT3D;
    x = 0;
    y = 0;
    hx = 1;
    hy = 1;
end

if H.level_ == 0
    figure();
    rectangle(...
        'Position', [x, y, hx, hy], ...
        'LineWidth', 2);
    axis equal;
    axis off;
    hold on;
end

if H.leaf_ == 0
    sub_hx = hx / 8;
    sub_hy = hy / 8;

    % Recursion on children.
    rit = 0;
    for rit3 = 1 : 2
        for rit2 = 1 : 2
            for rit1 = 1 : 2
                rit = rit + 1;
                cit = 0;
                for cit3 = 1 : 2
                    for cit2 = 1 : 2
                        for cit1 = 1 : 2
                            cit = cit + 1;
                            H.ch_{rit1, rit2, rit3, cit1, cit2, cit3}.PlotHMat(...
                                x + (8 - rit) * sub_hx, y + (cit - 1) * sub_hy, ...
                                sub_hx, sub_hy);
                        end
                    end
                end
            end
        end
    end
else
    if H.ad_ == 0
        rectangle(...
            'Position', [x, y, hx, hy], ...
            'LineWidth', 2, ...
            'FaceColor', [0.9290 0.6940 0.1250]);
    else
        rectangle(...
            'Position', [x, y, hx, hy], ...
            'LineWidth', 2, ...
            'FaceColor', [0.3010 0.7450 0.9330]);
    end
end

if H.level_ == 0
    hold off;
end

end
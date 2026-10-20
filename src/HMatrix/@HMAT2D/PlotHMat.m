function PlotHMat(H, x, y, hx, hy)
% PlotHMat

arguments (Input)
    H HMAT2D;
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
    sub_hx = hx / 4;
    sub_hy = hy / 4;

    % Recursion on children.
    rit = 0;
    for rit2 = 1 : 2
        for rit1 = 1 : 2
            rit = rit + 1;
            cit = 0;
            for cit2 = 1 : 2
                for cit1 = 1 : 2
                    cit = cit + 1;
                    H.ch_{rit1, rit2, cit1, cit2}.PlotHMat(...
                        x + (4 - rit) * sub_hx, y + (cit - 1) * sub_hy, ...
                        sub_hx, sub_hy);
                end
            end
        end
    end
else
    if H.ad_ == 0
        rectangle(...
            'Position', [x, y, hx, hy], ...
            'LineWidth', 2, ...
            'FaceColor', [1.00, 0.65, 0.00]);
        line([x, x + hx], [y, y + hy], ...
            'Color', [0.15, 0.15, 0.15], ...
            'LineWidth', 0.75);
        line([x, x + hx], [y + hy, y], ...
            'Color', [0.15, 0.15, 0.15], ...
            'LineWidth', 0.75);
    else
        rectangle(...
            'Position', [x, y, hx, hy], ...
            'LineWidth', 2, ...
            'FaceColor', [0.00, 0.45, 0.70]);
    end
end

if H.level_ == 0
    hold off;
end

end

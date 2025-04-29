function PlotLevelTree(T, target_level)

% Note: Only support full tree.

arguments (Input)
    T ClusterTree2D;
    target_level (1, 1) double;
end

if T.level_ == 0
    figure();
    % rectangle( ...
    %     'Position', [0, 0, 1, 0.1], ...
    %     'LineWidth', 2);
    axis equal;
    axis off;
    hold on;
end

if T.level_ == target_level || T.leaf_ == 1
    hx1 = 1 / T.B_.I1_.global_size_;
    hx2 = 1 / T.B_.I2_.global_size_;
    h = min([hx1, hx2]);
    x_points = T.B_.Points();
    T_color = [...
        T.B_.x1RightPoint(), ...
        T.B_.x2RightPoint(), ...
        1 - T.B_.x1RightPoint() * T.B_.x2RightPoint()];
    for i = 1 : size(x_points, 1)
        rectangle( ...
            'Curvature', [1 1], ...
            'Position', [...
            x_points(i, 1) - h / 3, ...
            x_points(i, 2) - h / 3, ...
            2 * h / 3, 2 * h / 3], ...
            'FaceColor', T_color, ...
            'LineWidth', 2);
    end
else
    for it2 = 1 : 2
        for it1 = 1 : 2
            T.ch_{it1, it2}.PlotLevelTree(target_level);
        end
    end
end

if T.level_ == 0
    hold off;
end

end
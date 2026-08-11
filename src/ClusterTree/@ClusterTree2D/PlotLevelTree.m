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
    x_points = T.B_.Points();

    block_x = floor((T.B_.I1_.left_ind_ - 1) / T.B_.I1_.size_);
    block_y = floor((T.B_.I2_.left_ind_ - 1) / T.B_.I2_.size_);
    shade_list = [0.96, 0.82, 0.68, 0.54];
    shade_ind = mod(block_x + 2 * block_y, length(shade_list)) + 1;
    shade = shade_list(shade_ind);

    num_blocks_x = T.B_.I1_.global_size_ / T.B_.I1_.size_;
    num_blocks_y = T.B_.I2_.global_size_ / T.B_.I2_.size_;
    num_colors = num_blocks_x * num_blocks_y;
    color_list = turbo(num_colors);
    linear_block_ind = block_x + num_blocks_x * block_y;
    color_ind = mod(5 * linear_block_ind, num_colors) + 1;
    point_color = color_list(color_ind, :);

    x_left = T.B_.x1LeftPoint() - hx1 / 2;
    y_left = T.B_.x2LeftPoint() - hx2 / 2;
    width = T.B_.x1RightPoint() - T.B_.x1LeftPoint() + hx1;
    height = T.B_.x2RightPoint() - T.B_.x2LeftPoint() + hx2;
    rectangle(...
        'Position', [x_left, y_left, width, height], ...
        'FaceColor', shade * ones(1, 3), ...
        'EdgeColor', [0.15, 0.15, 0.15], ...
        'LineWidth', 1.25);

    marker_list = {'o', 's', 'd', '^'};
    marker_ind = mod(block_x + block_y, length(marker_list)) + 1;
    plot(x_points(:, 1), x_points(:, 2), ...
        'LineStyle', 'none', ...
        'Marker', marker_list{marker_ind}, ...
        'MarkerSize', 7, ...
        'MarkerFaceColor', point_color, ...
        'MarkerEdgeColor', [0, 0, 0], ...
        'LineWidth', 1.25);
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

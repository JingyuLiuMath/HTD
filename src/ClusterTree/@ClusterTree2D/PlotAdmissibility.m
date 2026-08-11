function PlotAdmissibility(T, target_leaf, ad)

arguments (Input)
    T ClusterTree2D;
    target_leaf Box2D;
    ad string;
end

self_color = [0.00, 0.70, 0.25];
admissible_color = [0.00, 0.40, 0.95];
inadmissible_color = [1.00, 0.65, 0.00];

if T.level_ == 0
    figure();
    axis equal;
    axis off;
    hold on;
end

if T.leaf_ == 1
    hx1 = 1 / T.B_.I1_.global_size_;
    hx2 = 1 / T.B_.I2_.global_size_;
    x_points = T.B_.Points();

    flag = Admissible2D(target_leaf, T.B_, ad);

    if T.B_ == target_leaf
        my_color = self_color;
        background_shade = 0.65;
        marker = 's';
    elseif flag == 1
        my_color = admissible_color;
        background_shade = 0.97;
        marker = 'o';
    else
        my_color = inadmissible_color;
        background_shade = 0.84;
        marker = 'd';
    end

    x_left = T.B_.x1LeftPoint() - hx1 / 2;
    y_left = T.B_.x2LeftPoint() - hx2 / 2;
    width = T.B_.x1RightPoint() - T.B_.x1LeftPoint() + hx1;
    height = T.B_.x2RightPoint() - T.B_.x2LeftPoint() + hx2;
    rectangle(...
        'Position', [x_left, y_left, width, height], ...
        'FaceColor', background_shade * ones(1, 3), ...
        'EdgeColor', 'none');

    plot(x_points(:, 1), x_points(:, 2), ...
        'LineStyle', 'none', ...
        'Marker', marker, ...
        'MarkerSize', 7, ...
        'MarkerFaceColor', my_color, ...
        'MarkerEdgeColor', [0, 0, 0], ...
        'LineWidth', 1.25);
else
    for it2 = 1 : 2
        for it1 = 1 : 2
            T.ch_{it1, it2}.PlotAdmissibility(target_leaf, ad);
        end
    end
end

if T.level_ == 0
    hold off;
end

end

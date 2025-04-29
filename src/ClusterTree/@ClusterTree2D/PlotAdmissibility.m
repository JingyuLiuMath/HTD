function PlotAdmissibility(T, target_leaf, ad)

arguments (Input)
    T ClusterTree2D;
    target_leaf Box2D;
    ad string;
end

self_color = [0.4660 0.6740 0.1880];
admissible_color = [0.3010 0.7450 0.9330];
inadmissible_color = [0.9290 0.6940 0.1250];

if T.level_ == 0
    figure();
    axis equal;
    axis off;
    hold on;
end

if T.leaf_ == 1
    hx1 = 1 / T.B_.I1_.global_size_;
    hx2 = 1 / T.B_.I2_.global_size_;
    h = min([hx1, hx2]);
    x_points = T.B_.Points();

    flag = Admissible2D(target_leaf, T.B_, ad);

    if T.B_ == target_leaf
        my_color = self_color;
    elseif flag == 1
        my_color = admissible_color;
    else
        my_color = inadmissible_color;
    end
    for i = 1 : size(x_points, 1)
        rectangle( ...
            'Curvature', [1 1], ...
            'Position', [...
            x_points(i, 1) - h / 3, ...
            x_points(i, 2) - h / 3, ...
            2 * h / 3, 2 * h / 3], ...
            'FaceColor', my_color, ...
            'LineWidth', 2);
    end
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
function [uni_id, qu_id, intersect_area] = PolyIntersect(T, qu_grid)

arguments (Input)
    T ClusterTree2D;
    qu_grid (:, 1) polyshape;
end

arguments (Output)
    uni_id (1, :) double;
    qu_id (1, :) double;
    intersect_area (1, :) double;
end

h1 = 1 / T.B_.I1_.global_size_;
h2 = 1 / T.B_.I2_.global_size_;
x1_left = T.B_.x1LeftPoint() - h1 / 2;
x1_right = T.B_.x1RightPoint() + h1 / 2;
x2_left = T.B_.x2LeftPoint() - h2 / 2;
x2_right = T.B_.x2RightPoint() + h2 / 2;

poly_uni = polyshape(...
    [x1_left, x1_right, x1_right, x1_left], ...
    [x2_left, x2_left, x2_right, x2_right]);

poly_intersect = intersect(poly_uni, qu_grid);
area_all_intersect = poly_intersect.area;
nnz_id = find(area_all_intersect)';
nnz_size = length(nnz_id);

if T.leaf_ == 1
    % Remember T only have 1 point.
    if nnz_size > 0
        uni_id = ones(1, nnz_size) * T.B_.GlobalInd();
        qu_id = nnz_id;
        intersect_area = area_all_intersect(nnz_id);
    else
        uni_id = [];
        qu_id = [];
        intersect_area = [];
    end
else
    uni_id = [];
    qu_id = [];
    intersect_area = [];
    for it2 = 1 : 2
        for it1 = 1 : 2
            [c_uni_id, c_qu_id, c_intersect_area] = PolyIntersect(...
                T.ch_{it1, it2}, qu_grid(nnz_id));
            uni_id = [uni_id, c_uni_id];
            qu_id = [qu_id, nnz_id(c_qu_id)];
            intersect_area = [intersect_area, c_intersect_area];
        end
    end
end

end
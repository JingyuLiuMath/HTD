function BuildTree(T, min_points)
% BuildTree

% Jingyu Liu, October 18, 2024.

arguments (Input)
    T ClusterTree2D;
    min_points (1, 1) double;
end

if T.B_.size_ <= min_points
    T.leaf_ = 1;
    T.max_level_ = T.level_;
    T.ind_ = T.B_.GlobalInd();
else
    T.leaf_ = 0;

    % Partition.
    B_children = T.B_.Partition();
    T.ch_ = cell(2, 2);
    T.ind_ = [];
    for it2 = 1 : 2
        for it1 = 1 : 2
            T.ch_{it1, it2} = ClusterTree2D(...
                B_children{it1, it2}, ...
                T.level_ + 1);
            T.ch_{it1, it2}.BuildTree(min_points);
            T.ind_ = [T.ind_; T.ch_{it1, it2}.ind_];
            T.max_level_ = max(T.max_level_, ...
                T.ch_{it1, it2}.max_level_);
        end
    end
end

[~, T.p_] = sort(T.ind_);
[~, T.q_] = sort(T.p_);

end
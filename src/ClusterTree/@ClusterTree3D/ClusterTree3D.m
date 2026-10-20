classdef ClusterTree3D < handle

    % Jingyu Liu, April 27, 2025.

    properties
        % Tree.
        level_ (1, 1) double = 0;
        leaf_ (1, 1) double = 1;
        max_level_ (1, 1) double = 0;
        ch_ (2, 2, 2) cell;

        B_ Box3D;
        ind_ (:, 1) double;  % leaf order.
        p_ (:, 1) double;  % perm to be consistent with the original order.
        q_ (:, 1) double;  % perm to be consistent with the leaf order.
    end

    methods
        function T = ClusterTree3D(B, level)
            arguments (Input)
                B Box3D;
                level (1, 1) double = 0;
            end

            arguments (Output)
                T ClusterTree3D;
            end

            T.B_ = B;
            T.level_ = level;
            
        end
    end

    
end


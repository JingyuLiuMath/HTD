classdef HTLR3D < handle
    % HTLR3D

    properties
        % Tree.
        level_ (1, 1) double = 0;
        leaf_ (1, 1) double = 1;
        ad_ (1, 1) double = 0;  % admissible.

        % Children.
        ch_ (2, 2, 2, 2, 2, 2) cell;

        % Matrix.
        rsize_ double;  % row.
        r1size_ double;
        r2size_ double;
        r3size_ double;
        csize_ double;  % col.
        c1size_ double;
        c2size_ double;
        c3size_ double;

        D_ (:, :, :, :, :, :) double;
        U1_ (:, :) double;
        U2_ (:, :) double;
        U3_ (:, :) double;
        G_ (:, :, :, :, :, :) double;
        V1_ (:, :) double;
        V2_ (:, :) double;
        V3_ (:, :) double;
    end

    methods
        function H = HTLR3D(...
                r1size, r2size, r3size, ...
                c1size, c2size, c3size, level)
            % HLR3D

            arguments (Input)
                r1size (1, 1) double;
                r2size (1, 1) double;
                r3size (1, 1) double
                c1size (1, 1) double;
                c2size (1, 1) double;
                c3size (1, 1) double;
                level (1, 1) double = 0;
            end

            arguments (Output)
                H HTLR3D;
            end

            H.r1size_ = r1size;
            H.r2size_ = r2size;
            H.r3size_ = r3size;
            H.c1size_ = c1size;
            H.c2size_ = c2size;
            H.c3size_ = c3size;
            H.level_ = level;

        end

    end


end
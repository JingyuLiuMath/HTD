classdef HMAT3D < handle
    % HMAT3D.

    properties
        % Tree.
        level_ (1, 1) double = 0;
        leaf_ (1, 1) double = 1;
        ad_ (1, 1) double = 0;  % admissible.

        % Children.
        ch_ (2, 2, 2, 2, 2, 2) cell;

        % Matrix.
        rsize_ (1, 1) double;  % row.
        csize_ (1, 1) double;  % col.
        D_ (:, :) double;
        U_ (:, :) double;
        G_ (:, :) double;
        V_ (:, :) double;
    end

    methods
        function H = HMAT3D(rsize, csize, level)
            % HLR3D

            arguments (Input)
                rsize (1, 1) double;
                csize (1, 1) double;
                level (1, 1) double = 0;
            end

            arguments (Output)
                H HMAT3D;
            end

            H.rsize_ = rsize;
            H.csize_ = csize;
            H.level_ = level;

        end

    end


end
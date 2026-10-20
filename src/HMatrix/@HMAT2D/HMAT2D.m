classdef HMAT2D < handle
    % HMAT2D.

    properties
        % Tree.
        level_ (1, 1) double = 0;
        leaf_ (1, 1) double = 1;
        ad_ (1, 1) double = 0;  % admissible.

        % Children.
        ch_ (2, 2, 2, 2) cell;

        % Matrix.
        rsize_ (1, 1) double;  % row.
        csize_ (1, 1)double;  % col.
        D_ (:, :) double;
        U_ (:, :) double;
        G_ (:, :) double;
        V_ (:, :) double;
    end

    methods
        function H = HMAT2D(rsize, csize, level)
            % HLR2D

            arguments (Input)
                rsize (1, 1) double;
                csize (1, 1) double;
                level (1, 1) double = 0;
            end

            arguments (Output)
                H HMAT2D;
            end

            H.rsize_ = rsize;
            H.csize_ = csize;
            H.level_ = level;

        end

    end


end
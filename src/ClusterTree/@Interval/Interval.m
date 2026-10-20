classdef Interval

    properties
        % Index.
        global_size_ (1, 1) double = 0;
        left_ind_ (1, 1) double = 0;
        right_ind_ (1, 1) double = 0;
        size_ (1, 1) double = 0;
    end

    methods
        function I = Interval(global_size, left_ind, right_ind)
            arguments (Input)
                global_size (1, 1) double;
                left_ind (1, 1) double = 1;
                right_ind (1, 1) double = global_size;
            end

            arguments (Output)
                I Interval;
            end

            I.global_size_ = global_size;
            I.left_ind_ = left_ind;
            I.right_ind_ = right_ind;
            I.size_ = right_ind - left_ind + 1;

        end
    end
    
end
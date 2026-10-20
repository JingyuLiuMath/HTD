classdef Box2D

    % Jingyu Liu, April 27, 2025.

    properties
        I1_ Interval;
        I2_ Interval;
        size_ (1, 1) double;
        global_size_ (1, 1) double;
        
    end

    methods
        function B = Box2D(I1, I2)
            arguments (Input)
                I1 Interval;
                I2 Interval;
            end

            arguments (Output)
                B Box2D;
            end

            B.I1_ = I1;
            B.I2_ = I2;
            B.size_ = I1.size_ * I2.size_;
            B.global_size_ = I1.global_size_ * I2.global_size_;
            
        end
    end 
end
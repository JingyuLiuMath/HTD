function f = Gaussian(x, y, sigma)

arguments (Input)
    x double;
    y double;
    sigma (1, 1) double = 1;
end

arguments (Output)
    f (:, :) double;
end

f = exp(-pdist2(x, y, "squaredeuclidean") / 2 / sigma^2);

end
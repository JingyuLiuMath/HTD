function ret = Admissible2D(B1, B2, admissibility)

arguments (Input)
    B1 Box2D;
    B2 Box2D;
    admissibility string;
end

arguments (Output)
    ret (1, 1) double;
end

switch admissibility
    case "strong"
        % Strong admissible.
        ret = (sqrt(2) * Distance(B1, B2) >= max(Diameter(B1), Diameter(B2)));
    case "weak"
        % Weak admissible.
        ret = ~(B1 == B2);
    case "inadmissible"
        % Inadmissible.
        ret = 0;
end

end
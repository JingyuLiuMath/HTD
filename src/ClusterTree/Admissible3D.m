function ret = Admissible3D(B1, B2, admissibility)

arguments (Input)
    B1 Box3D;
    B2 Box3D;
    admissibility string;
end

arguments (Output)
    ret (1, 1) double;
end

switch admissibility
    case "strong"
        % Strong admissible.
        ret = max(Diameter(B1), Diameter(B2)) <= sqrt(3) * Distance(B1, B2);
    case "weak"
        % Weak admissible.
        ret = ~(B1 == B2);
    case "inadmissible"
        % Inadmissible.
        ret = 0;
end

end
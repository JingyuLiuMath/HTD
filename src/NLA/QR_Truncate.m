function [Q, R, p] = QR_Truncate(A, tol)
% QR_Truncate

% Jingyu Liu, December 18, 2024.

arguments (Input)
    A (:, :) double;
    tol (1, 1) double;
end

arguments (Output)
    Q (:, :) double;
    R (:, :) double;
    p (:, 1) double;
end

[m, n] = size(A);

[Q, R, p] = qr(A, "vector");

if isempty(A)
    keyboard;
end

if 1
    r_value = tol * abs(R(1, 1));
else
    r_value = tol;
end
k = min(find(abs(diag(R)) >= r_value, 1, "last"), ...
    size(R, 2));
sign_diag_R = sign(diag(R((k + 1) : n, (k + 1) : n)));
R((k + 1) : n, (k + 1) : n) = triu(R((k + 1) : n, (k + 1) : n), 1) ...
    + diag(r_value * sign_diag_R);

if nargout == 2
    [~, q] = sort(p, "ascend");
    R = R(:, q);
end

end

% dP = [dP;dP];
% P  = [P ; P];
% Pf = [Pf;Pf];
% SBPA = [SBPA;SBPA];

[rows,columns] = size(y);
if rows<columns,
    y = [y y];
    u = [u u];
    p = [p p];
else,
    y = [y; y];
    u = [u; u];
    p = [p; p];
end

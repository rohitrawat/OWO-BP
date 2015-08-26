function t = generate_t(ic, M, Nv)
% Generates desired outputs as 0 for incorrect class, 1 for correct class.
b = 1;
% t = ones(Nv,M)*(-b);
if(nargin < 3)
    Nv = size(ic,1);
end
t = zeros(Nv,M);
for p=1:Nv
    t(p,ic(p)) = b;
end
